package src5;

import com.smartfoxserver.v2.entities.Room;
import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.data.ISFSObject;
import com.smartfoxserver.v2.entities.data.SFSArray;
import com.smartfoxserver.v2.entities.data.SFSObject;
import com.smartfoxserver.v2.exceptions.SFSJoinRoomException;
import java.util.List;

public class GlobalChatJoinHandler extends OsBaseHandler {
    public static final String COMMAND = "globalchat.join";
    private static final String GLOBAL_ROOM = "chat";

    @Override
    public void handleClientRequest(User user, ISFSObject params) {
        Room room = getParentExtension().getParentZone().getRoomByName(GLOBAL_ROOM);
        if (room == null) {
            sendError(user, "ROOM_NOT_FOUND", "Global chat room not found");
            return;
        }

        try {
            if (user.getLastJoinedRoom() == null || !user.getLastJoinedRoom().getName().equals(GLOBAL_ROOM)) {
                getApi().joinRoom(user, room);
            }
        } catch (SFSJoinRoomException e) {
            sendError(user, "JOIN_FAILED", e.getMessage());
            return;
        }

        sendSync(user);
    }

    private void sendSync(User user) {
        List<SFSObject> messages = GlobalChatServices.getStore().getMessages();
        SFSArray list = new SFSArray();
        for (SFSObject message : messages) {
            list.addSFSObject(message);
        }
        SFSObject payload = new SFSObject();
        payload.putSFSArray("messages", list);
        send("chat.sync", payload, user);
    }

    private void sendError(User user, String code, String message) {
        SFSObject error = new SFSObject();
        error.putUtfString("errorCode", code);
        error.putUtfString("message", message);
        send(COMMAND, error, user);
    }
}
