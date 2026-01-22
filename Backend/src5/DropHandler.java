package src5;

import com.smartfoxserver.v2.entities.Room;
import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.data.ISFSObject;
import com.smartfoxserver.v2.entities.data.SFSObject;
import java.util.List;

public class DropHandler extends OsBaseHandler {
    public static final String COMMAND = "drop";

    @Override
    public void handleClientRequest(User sender, ISFSObject params) {
        String type = params != null && params.containsKey("type")
            ? params.getUtfString("type")
            : null;
        if (type == null || !"COLLECT".equalsIgnoreCase(type)) {
            sendError(sender, "INVALID_TYPE", "type is required");
            return;
        }

        if (params == null || !params.containsKey("x") || !params.containsKey("y") || !params.containsKey("clip")) {
            sendError(sender, "INVALID_ITEM", "x, y, clip are required");
            return;
        }

        int x = params.getInt("x");
        int y = params.getInt("y");
        String clip = params.getUtfString("clip");

        Room room = sender.getLastJoinedRoom();
        if (room == null) {
            room = getParentExtension().getParentRoom();
        }
        if (room == null) {
            sendError(sender, "ROOM_NOT_FOUND", "Room is required");
            return;
        }

        SFSObject payload = new SFSObject();
        payload.putInt("x", x);
        payload.putInt("y", y);
        payload.putUtfString("clip", clip);
        List<User> recipients = room.getUserList();
        send("dropRemoveItem", payload, recipients);

        send(COMMAND, new SFSObject(), sender);
    }

    private void sendError(User user, String code, String message) {
        SFSObject error = new SFSObject();
        error.putUtfString("errorCode", code);
        error.putUtfString("message", message);
        send(COMMAND, error, user);
    }
}
