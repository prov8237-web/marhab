package src5;

import com.smartfoxserver.v2.entities.Room;
import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.data.ISFSObject;
import com.smartfoxserver.v2.entities.data.SFSObject;

public class GlobalChatLeaveHandler extends OsBaseHandler {
    public static final String COMMAND = "globalchat.leave";
    private static final String GLOBAL_ROOM = "chat";

    @Override
    public void handleClientRequest(User user, ISFSObject params) {
        Room room = getParentExtension().getParentZone().getRoomByName(GLOBAL_ROOM);
        if (room == null) {
            sendError(user, "ROOM_NOT_FOUND", "Global chat room not found");
            return;
        }
        try {
            getApi().leaveRoom(user, room);
        } catch (Exception e) {
            sendError(user, "LEAVE_FAILED", e.getMessage());
            return;
        }
        send(COMMAND, new SFSObject(), user);
    }

    private void sendError(User user, String code, String message) {
        SFSObject error = new SFSObject();
        error.putUtfString("errorCode", code);
        error.putUtfString("message", message);
        send(COMMAND, error, user);
    }
}
