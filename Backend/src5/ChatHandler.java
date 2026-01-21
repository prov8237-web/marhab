package src5;

import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.data.ISFSObject;
import com.smartfoxserver.v2.entities.data.SFSObject;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

public class ChatHandler extends OsBaseHandler {
    
    @Override
    public void handleClientRequest(User sender, ISFSObject params) {
        ChatService service = ChatServices.getService();
        com.smartfoxserver.v2.entities.Room room = sender.getLastJoinedRoom();
        String rawMessage = params != null && params.containsKey("message")
            ? params.getUtfString("message")
            : "";
        ChatService.ChatResult result = service.processPublicMessage(sender, room, rawMessage);
        if (!result.isSuccess()) {
            sendError(sender, result.getRoomId(), result.getErrorCode(), result.getErrorMessage());
            return;
        }

        ChatMessage chatMessage = result.getMessage();
        SFSObject payload = service.buildNewPayload(chatMessage);
        Collection<User> recipientCollection = room != null ? room.getUserList() : getParentExtension().getParentZone().getUserList();
        List<User> recipients = new ArrayList<>(recipientCollection);
        send("chat.public.message", payload, recipients);

        if (service.getConfig().isLegacyEventsEnabled()) {
            SFSObject legacyPayload = service.buildLegacyPublicPayload(sender, chatMessage);
            send("publicMessage", legacyPayload, recipients);
        }

        trace("[CHAT_COMPAT] result=OK userId=" + chatMessage.getSenderId()
            + " roomId=" + chatMessage.getRoomId()
            + " messageId=" + chatMessage.getId()
            + " type=" + chatMessage.getMessageType()
            + " ts=" + chatMessage.getSentAt());
    }

    private void sendError(User user, String roomId, String code, String message) {
        SFSObject error = new SFSObject();
        error.putUtfString("errorCode", code);
        error.putUtfString("message", message);
        error.putUtfString("roomId", roomId);
        send("chat.public.error", error, user);
        trace("[CHAT_COMPAT] result=ERROR userId=" + user.getName() + " roomId=" + roomId + " code=" + code);
    }
}
