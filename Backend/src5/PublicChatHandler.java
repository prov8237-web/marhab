package src5;

import com.smartfoxserver.v2.entities.Room;
import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.data.SFSObject;
import java.util.Collection;

public class PublicChatHandler extends OsBaseHandler {
    public static final String COMMAND = "chat.public.send";
    public static final String RESPONSE_EVENT = "chat.public.message";

    @Override
    public void handleClientRequest(User user, com.smartfoxserver.v2.entities.data.ISFSObject params) {
        ChatService service = ChatServices.getService();
        Room room = user.getLastJoinedRoom();
        String rawMessage = params != null && params.containsKey("message")
            ? params.getUtfString("message")
            : "";
        ChatService.ChatResult result = service.processPublicMessage(user, room, rawMessage);
        if (!result.isSuccess()) {
            sendError(user, result.getRoomId(), result.getErrorCode(), result.getErrorMessage());
            return;
        }

        ChatMessage chatMessage = result.getMessage();
        SFSObject payload = service.buildNewPayload(chatMessage);
        Collection<User> recipients = room != null ? room.getUserList() : getParentExtension().getParentZone().getUserList();
        send(RESPONSE_EVENT, payload, recipients);

        if (service.getConfig().isLegacyEventsEnabled()) {
            SFSObject legacyPayload = service.buildLegacyPublicPayload(user, chatMessage);
            send("publicMessage", legacyPayload, recipients);
        }

        traceLog(chatMessage, "OK");
    }

    private void sendError(User user, String roomId, String code, String message) {
        SFSObject error = new SFSObject();
        error.putUtfString("errorCode", code);
        error.putUtfString("message", message);
        error.putUtfString("roomId", roomId);
        send("chat.public.error", error, user);
        trace("[CHAT_PUBLIC] result=ERROR userId=" + user.getName() + " roomId=" + roomId + " code=" + code);
    }

    private void traceLog(ChatMessage message, String result) {
        trace("[CHAT_PUBLIC] result=" + result
            + " userId=" + message.getSenderId()
            + " roomId=" + message.getRoomId()
            + " messageId=" + message.getId()
            + " type=" + message.getMessageType()
            + " ts=" + message.getSentAt());
    }
}
