package src5;

import com.smartfoxserver.v2.entities.Room;
import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.data.ISFSObject;
import com.smartfoxserver.v2.entities.data.SFSObject;

public class WhisperHandler extends OsBaseHandler {

    @Override
    public void handleClientRequest(User sender, ISFSObject params) {
        ChatService service = ChatServices.getService();
        Room room = sender.getLastJoinedRoom();
        String rawMessage = params != null && params.containsKey("message")
            ? params.getUtfString("message")
            : "";
        String receiverId = params != null && params.containsKey("receiverId")
            ? params.getUtfString("receiverId")
            : (params != null && params.containsKey("receiver") ? params.getUtfString("receiver") : "");
        ChatService.ChatResult result = service.processWhisper(sender, room, rawMessage, receiverId);
        if (!result.isSuccess()) {
            sendError(sender, result.getRoomId(), result.getErrorCode(), result.getErrorMessage());
            return;
        }

        ChatMessage chatMessage = result.getMessage();
        User receiver = room != null ? room.getZone().getUserByName(chatMessage.getReceiverId()) : null;
        if (receiver == null) {
            sendError(sender, chatMessage.getRoomId(), "USER_NOT_FOUND", "Receiver not found");
            return;
        }

        SFSObject payload = service.buildNewPayload(chatMessage);
        send("chat.whisper.message", payload, sender);
        send("chat.whisper.message", payload, receiver);

        if (service.getConfig().isLegacyEventsEnabled()) {
            SFSObject legacyPayload = service.buildLegacyWhisperPayload(sender, receiver, chatMessage);
            send("whisper", legacyPayload, sender);
            send("whisper", legacyPayload, receiver);

            if (room != null) {
                SFSObject notifyPayload = service.buildLegacyWhisperNotifyPayload(sender, receiver);
                for (User roomUser : room.getUserList()) {
                    if (!roomUser.getName().equals(sender.getName())
                        && !roomUser.getName().equals(receiver.getName())) {
                        send("whispernotify", notifyPayload, roomUser);
                    }
                }
            }
        }

        trace("[WHISPER_COMPAT] result=OK userId=" + chatMessage.getSenderId()
            + " roomId=" + chatMessage.getRoomId()
            + " messageId=" + chatMessage.getId()
            + " type=" + chatMessage.getMessageType()
            + " ts=" + chatMessage.getSentAt());
    }

    private void sendError(User user, String roomId, String code, String message) {
        SFSObject errorResponse = new SFSObject();
        errorResponse.putUtfString("errorCode", code);
        errorResponse.putUtfString("message", message);
        errorResponse.putUtfString("roomId", roomId);

        send("chat.whisper.error", errorResponse, user);
        trace("[WHISPER_COMPAT] result=ERROR userId=" + user.getName() + " roomId=" + roomId + " code=" + code);
    }
}
