package src5;

import com.smartfoxserver.v2.entities.Room;
import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.data.ISFSObject;
import com.smartfoxserver.v2.entities.data.SFSArray;
import com.smartfoxserver.v2.entities.data.SFSObject;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

public class GlobalChatMessageHandler extends OsBaseHandler {
    public static final String COMMAND = "chat.message";
    private static final String GLOBAL_ROOM = "chat";

    @Override
    public void handleClientRequest(User user, ISFSObject params) {
        ChatService service = ChatServices.getService();
        Room room = getParentExtension().getParentZone().getRoomByName(GLOBAL_ROOM);
        String rawMessage = params != null && params.containsKey("message")
            ? params.getUtfString("message")
            : "";
        ChatService.ChatResult result = service.processPublicMessage(user, room, rawMessage);
        if (!result.isSuccess()) {
            sendError(user, result.getRoomId(), result.getErrorCode(), result.getErrorMessage());
            return;
        }

        if (room == null) {
            sendError(user, "", "ROOM_NOT_FOUND", "Global chat room not found");
            return;
        }

        SFSObject payload = buildGlobalPayload(user, result.getMessage().getMessage());
        GlobalChatServices.getStore().addMessage(payload);

        Collection<User> recipientCollection = room.getUserList();
        List<User> recipients = new ArrayList<>(recipientCollection);
        send(COMMAND, payload, recipients);

        SFSObject response = new SFSObject();
        response.putInt("nextMessage", 0);
        send(COMMAND, response, user);

        trace("[GLOBAL_CHAT] message sent userId=" + user.getName() + " room=" + GLOBAL_ROOM);
    }

    private SFSObject buildGlobalPayload(User user, String message) {
        SFSObject payload = new SFSObject();
        payload.putUtfString("avatarID", user.getName());
        payload.putUtfString("avatarName", getAvatarName(user));
        payload.putUtfString("message", message);
        payload.putInt("frameNo", getChatBalloonType(user));
        return payload;
    }

    private String getAvatarName(User user) {
        if (user != null && user.containsVariable("avatarName")) {
            String value = user.getVariable("avatarName").getStringValue();
            if (value != null && !value.isEmpty()) {
                return value;
            }
        }
        return user != null ? user.getName() : "";
    }

    private int getChatBalloonType(User user) {
        if (user != null && user.containsVariable("chatBalloon")) {
            return user.getVariable("chatBalloon").getIntValue();
        }
        return 1;
    }

    private void sendError(User user, String roomId, String code, String message) {
        SFSObject error = new SFSObject();
        error.putUtfString("errorCode", code);
        error.putUtfString("message", message);
        error.putUtfString("roomId", roomId);
        send(COMMAND, error, user);
    }
}
