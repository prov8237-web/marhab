package src5;

import com.smartfoxserver.v2.entities.Room;
import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.data.SFSObject;

public class WhisperChatHandler extends OsBaseHandler {
    public static final String COMMAND = "chat.whisper.send";
    public static final String RESPONSE_EVENT = "chat.whisper.message";

    @Override
    public void handleClientRequest(User user, com.smartfoxserver.v2.entities.data.ISFSObject params) {
        ChatService service = ChatServices.getService();
        Room room = user.getLastJoinedRoom();
        String rawMessage = params != null && params.containsKey("message")
            ? params.getUtfString("message")
            : "";
        String receiverId = params != null && params.containsKey("receiverId")
            ? params.getUtfString("receiverId")
            : "";
        ChatService.ChatResult result = service.processWhisper(user, room, rawMessage, receiverId);
        if (!result.isSuccess()) {
            sendError(user, result.getRoomId(), result.getErrorCode(), result.getErrorMessage());
            return;
        }

        ChatMessage chatMessage = result.getMessage();
        User receiver = room != null ? room.getZone().getUserByName(chatMessage.getReceiverId()) : null;
        if (receiver == null) {
            sendError(user, chatMessage.getRoomId(), "USER_NOT_FOUND", "Receiver not found");
            return;
        }

        SFSObject payload = service.buildNewPayload(chatMessage);
        send(RESPONSE_EVENT, payload, user);
        send(RESPONSE_EVENT, payload, receiver);

        if (service.getConfig().isLegacyEventsEnabled()) {
            SFSObject legacyPayload = service.buildLegacyWhisperPayload(user, receiver, chatMessage);
            send("whisper", legacyPayload, user);
            send("whisper", legacyPayload, receiver);

            if (room != null) {
                SFSObject notifyPayload = service.buildLegacyWhisperNotifyPayload(user, receiver);
                for (User roomUser : room.getUserList()) {
                    if (!roomUser.getName().equals(user.getName())
                        && !roomUser.getName().equals(receiver.getName())) {
                        send("whispernotify", notifyPayload, roomUser);
                    }
                }
            }
        }

        traceLog(chatMessage, "OK");
    }

    private void sendError(User user, String roomId, String code, String message) {
        SFSObject error = new SFSObject();
        error.putUtfString("errorCode", code);
        error.putUtfString("message", message);
        error.putUtfString("roomId", roomId);
        send("chat.whisper.error", error, user);
        trace("[CHAT_WHISPER] result=ERROR userId=" + user.getName() + " roomId=" + roomId + " code=" + code);
    }

    private void traceLog(ChatMessage message, String result) {
        trace("[CHAT_WHISPER] result=" + result
            + " userId=" + message.getSenderId()
            + " roomId=" + message.getRoomId()
            + " messageId=" + message.getId()
            + " type=" + message.getMessageType()
            + " ts=" + message.getSentAt());
    }
}
