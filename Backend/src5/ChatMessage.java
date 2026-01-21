package src5;

import java.util.UUID;

public class ChatMessage {
    private final UUID id;
    private final String roomId;
    private final String senderId;
    private final String receiverId;
    private final String message;
    private final ChatMessageType messageType;
    private final long sentAt;

    public ChatMessage(UUID id,
                       String roomId,
                       String senderId,
                       String receiverId,
                       String message,
                       ChatMessageType messageType,
                       long sentAt) {
        this.id = id;
        this.roomId = roomId;
        this.senderId = senderId;
        this.receiverId = receiverId;
        this.message = message;
        this.messageType = messageType;
        this.sentAt = sentAt;
    }

    public UUID getId() {
        return id;
    }

    public String getRoomId() {
        return roomId;
    }

    public String getSenderId() {
        return senderId;
    }

    public String getReceiverId() {
        return receiverId;
    }

    public String getMessage() {
        return message;
    }

    public ChatMessageType getMessageType() {
        return messageType;
    }

    public long getSentAt() {
        return sentAt;
    }
}
