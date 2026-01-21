package src5;

import java.util.ArrayDeque;
import java.util.Deque;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

public class InMemoryChatStore {
    private final int roomHistoryLimit;
    private final Map<String, Deque<ChatMessage>> roomMessages = new ConcurrentHashMap<>();

    public InMemoryChatStore(int roomHistoryLimit) {
        this.roomHistoryLimit = roomHistoryLimit;
    }

    public void addMessage(ChatMessage message) {
        if (message == null) {
            return;
        }
        String roomId = message.getRoomId();
        if (roomId == null) {
            return;
        }
        Deque<ChatMessage> deque = roomMessages.computeIfAbsent(roomId, key -> new ArrayDeque<>());
        synchronized (deque) {
            deque.addLast(message);
            while (deque.size() > roomHistoryLimit) {
                deque.removeFirst();
            }
        }
    }

    public Deque<ChatMessage> getRecentMessages(String roomId) {
        Deque<ChatMessage> deque = roomMessages.get(roomId);
        if (deque == null) {
            return new ArrayDeque<>();
        }
        synchronized (deque) {
            return new ArrayDeque<>(deque);
        }
    }
}
