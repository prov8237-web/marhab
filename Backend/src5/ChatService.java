package src5;

import com.smartfoxserver.v2.entities.Room;
import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.data.SFSObject;
import java.util.ArrayDeque;
import java.util.Deque;
import java.util.Map;
import java.util.UUID;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.atomic.AtomicLong;

public class ChatService {
    private final ChatConfig config;
    private final InMemoryChatStore store;
    private final Map<String, Deque<Long>> rateLimitBuckets = new ConcurrentHashMap<>();
    private final Map<String, Long> muteUntil = new ConcurrentHashMap<>();
    private final AtomicLong publicReceived = new AtomicLong();
    private final AtomicLong whisperReceived = new AtomicLong();
    private final AtomicLong rejected = new AtomicLong();
    private final AtomicLong filtered = new AtomicLong();
    private final AtomicLong muted = new AtomicLong();
    private final ScheduledExecutorService metricsScheduler = Executors.newSingleThreadScheduledExecutor();

    public ChatService(ChatConfig config, InMemoryChatStore store) {
        this.config = config;
        this.store = store;
        startMetricsLogger();
    }

    public ChatConfig getConfig() {
        return config;
    }

    public InMemoryChatStore getStore() {
        return store;
    }

    public String validateMessage(String message) {
        if (message == null) {
            return "";
        }
        String trimmed = message.trim();
        if (trimmed.isEmpty()) {
            return "";
        }
        if (trimmed.length() > config.getMaxLength()) {
            return trimmed.substring(0, config.getMaxLength());
        }
        return trimmed;
    }

    public boolean checkPermissions(User user, Room room) {
        return true;
    }

    public boolean rateLimit(String userId) {
        if (userId == null) {
            return false;
        }
        long now = System.currentTimeMillis();
        long windowMs = config.getRateLimitWindowMs();
        int limit = config.getRateLimitCount();
        Deque<Long> bucket = rateLimitBuckets.computeIfAbsent(userId, key -> new ArrayDeque<>());
        synchronized (bucket) {
            while (!bucket.isEmpty() && now - bucket.peekFirst() > windowMs) {
                bucket.removeFirst();
            }
            if (bucket.size() >= limit) {
                return false;
            }
            bucket.addLast(now);
        }
        return true;
    }

    public ChatMessage buildChatMessage(String roomId,
                                        String senderId,
                                        String receiverId,
                                        String message,
                                        ChatMessageType type) {
        return new ChatMessage(
            UUID.randomUUID(),
            roomId,
            senderId,
            receiverId,
            message,
            type,
            System.currentTimeMillis()
        );
    }

    public ChatResult processPublicMessage(User sender, Room room, String rawMessage) {
        String roomId = room != null ? room.getName() : "";
        publicReceived.incrementAndGet();

        String muteError = checkMute(sender);
        if (muteError != null) {
            muted.incrementAndGet();
            return ChatResult.error("MUTED", muteError, roomId);
        }

        String message = validateMessage(rawMessage);

        if (!checkPermissions(sender, room)) {
            rejected.incrementAndGet();
            return ChatResult.error("PERMISSION_DENIED", "Permission denied", roomId);
        }

        if (message.isEmpty()) {
            rejected.incrementAndGet();
            return ChatResult.error("EMPTY_MESSAGE", "Message is empty", roomId);
        }

        if (isBlacklisted(message)) {
            filtered.incrementAndGet();
            return ChatResult.error("BLACKLISTED", "Message contains blocked words", roomId);
        }

        if (!rateLimit(sender.getName())) {
            rejected.incrementAndGet();
            return ChatResult.error("RATE_LIMIT", "Rate limit exceeded", roomId);
        }

        ChatMessage chatMessage = buildChatMessage(
            roomId,
            sender.getName(),
            null,
            message,
            ChatMessageType.PUBLIC
        );
        store.addMessage(chatMessage);
        return ChatResult.success(chatMessage);
    }

    public ChatResult processWhisper(User sender, Room room, String rawMessage, String receiverId) {
        String roomId = room != null ? room.getName() : "";
        whisperReceived.incrementAndGet();

        String muteError = checkMute(sender);
        if (muteError != null) {
            muted.incrementAndGet();
            return ChatResult.error("MUTED", muteError, roomId);
        }

        String message = validateMessage(rawMessage);

        if (!checkPermissions(sender, room)) {
            rejected.incrementAndGet();
            return ChatResult.error("PERMISSION_DENIED", "Permission denied", roomId);
        }

        if (message.isEmpty() || receiverId == null || receiverId.isEmpty()) {
            rejected.incrementAndGet();
            return ChatResult.error("INVALID_REQUEST", "Invalid whisper payload", roomId);
        }

        if (isBlacklisted(message)) {
            filtered.incrementAndGet();
            return ChatResult.error("BLACKLISTED", "Message contains blocked words", roomId);
        }

        if (!rateLimit(sender.getName())) {
            rejected.incrementAndGet();
            return ChatResult.error("RATE_LIMIT", "Rate limit exceeded", roomId);
        }

        User receiver = room != null ? room.getZone().getUserByName(receiverId) : null;
        if (receiver == null) {
            rejected.incrementAndGet();
            return ChatResult.error("USER_NOT_FOUND", "Receiver not found", roomId);
        }

        ChatMessage chatMessage = buildChatMessage(
            roomId,
            sender.getName(),
            receiver.getName(),
            message,
            ChatMessageType.WHISPER
        );
        return ChatResult.success(chatMessage);
    }

    public SFSObject buildNewPayload(ChatMessage message) {
        SFSObject payload = new SFSObject();
        payload.putUtfString("id", message.getId().toString());
        payload.putUtfString("roomId", message.getRoomId());
        payload.putUtfString("senderId", message.getSenderId());
        if (message.getReceiverId() != null) {
            payload.putUtfString("receiverId", message.getReceiverId());
        }
        payload.putUtfString("message", message.getMessage());
        payload.putUtfString("messageType", message.getMessageType().name());
        payload.putLong("sentAt", message.getSentAt());
        return payload;
    }

    public SFSObject buildLegacyPublicPayload(User sender, ChatMessage message) {
        SFSObject payload = new SFSObject();
        payload.putUtfString("sender", sender.getName());
        payload.putUtfString("message", message.getMessage());
        payload.putInt("chatBalloon", getChatBalloonType(sender));
        payload.putLong("ts", message.getSentAt());
        return payload;
    }

    public SFSObject buildLegacyWhisperPayload(User sender, User receiver, ChatMessage message) {
        SFSObject payload = new SFSObject();
        payload.putUtfString("sender", sender.getName());
        payload.putUtfString("receiver", receiver.getName());
        payload.putUtfString("message", message.getMessage());
        payload.putInt("chatBalloon", 11);
        return payload;
    }

    public SFSObject buildLegacyWhisperNotifyPayload(User sender, User receiver) {
        SFSObject payload = new SFSObject();
        payload.putUtfString("sender", sender.getName());
        payload.putUtfString("receiver", receiver.getName());
        return payload;
    }

    private int getChatBalloonType(User user) {
        if (user != null && user.containsVariable("chatBalloon")) {
            return user.getVariable("chatBalloon").getIntValue();
        }
        return 1;
    }

    public void muteUser(String userId, long untilTimestamp) {
        if (userId == null) {
            return;
        }
        muteUntil.put(userId, untilTimestamp);
    }

    public void clearMute(String userId) {
        if (userId == null) {
            return;
        }
        muteUntil.remove(userId);
    }

    private String checkMute(User user) {
        if (user == null) {
            return null;
        }
        Long until = muteUntil.get(user.getName());
        if (until == null) {
            return null;
        }
        long now = System.currentTimeMillis();
        if (now >= until) {
            muteUntil.remove(user.getName());
            return null;
        }
        long remainingMs = until - now;
        return "Muted for " + remainingMs + "ms";
    }

    private boolean isBlacklisted(String message) {
        if (message == null) {
            return false;
        }
        String lower = message.toLowerCase();
        for (String word : config.getBlacklist()) {
            if (word == null || word.isEmpty()) {
                continue;
            }
            if (lower.contains(word.toLowerCase())) {
                return true;
            }
        }
        return false;
    }

    private void startMetricsLogger() {
        metricsScheduler.scheduleAtFixedRate(() -> {
            String summary = "[CHAT_METRICS] public=" + publicReceived.get()
                + " whisper=" + whisperReceived.get()
                + " rejected=" + rejected.get()
                + " filtered=" + filtered.get()
                + " muted=" + muted.get();
            System.out.println(summary);
        }, 60, 60, TimeUnit.SECONDS);
    }

    public static class ChatResult {
        private final boolean success;
        private final ChatMessage message;
        private final String errorCode;
        private final String errorMessage;
        private final String roomId;

        private ChatResult(boolean success,
                           ChatMessage message,
                           String errorCode,
                           String errorMessage,
                           String roomId) {
            this.success = success;
            this.message = message;
            this.errorCode = errorCode;
            this.errorMessage = errorMessage;
            this.roomId = roomId;
        }

        public static ChatResult success(ChatMessage message) {
            return new ChatResult(true, message, null, null, message.getRoomId());
        }

        public static ChatResult error(String errorCode, String errorMessage, String roomId) {
            return new ChatResult(false, null, errorCode, errorMessage, roomId);
        }

        public boolean isSuccess() {
            return success;
        }

        public ChatMessage getMessage() {
            return message;
        }

        public String getErrorCode() {
            return errorCode;
        }

        public String getErrorMessage() {
            return errorMessage;
        }

        public String getRoomId() {
            return roomId;
        }
    }
}
