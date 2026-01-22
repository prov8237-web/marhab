package src5;

import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.data.ISFSObject;
import com.smartfoxserver.v2.entities.data.SFSObject;

public class BarterRequestHandler extends OsBaseHandler {
    public static final String COMMAND = "barterrequest";

    @Override
    public void handleClientRequest(User sender, ISFSObject params) {
        String receiverId = params != null && params.containsKey("avatarID")
            ? params.getUtfString("avatarID")
            : null;

        if (receiverId == null || receiverId.isEmpty()) {
            sendError(sender, "INVALID_TARGET", "avatarID is required");
            return;
        }

        User receiver = getApi().getUserByName(receiverId);
        if (receiver == null) {
            sendError(sender, "USER_NOT_FOUND", "Target user not found");
            return;
        }

        BarterStore.BarterSession session = BarterServices.getStore().createSession(sender, receiver);
        SFSObject payload = new SFSObject();
        payload.putUtfString("barterID", session.getId());
        payload.putUtfString("senderID", session.getSenderId());
        send("respondBarterRequest", payload, receiver);
    }

    private void sendError(User user, String code, String message) {
        SFSObject error = new SFSObject();
        error.putUtfString("errorCode", code);
        error.putUtfString("message", message);
        send(COMMAND, error, user);
    }
}
