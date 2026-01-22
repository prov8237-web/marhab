package src5;

import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.data.ISFSObject;
import com.smartfoxserver.v2.entities.data.SFSObject;

public class BarterCancelHandler extends OsBaseHandler {
    public static final String COMMAND = "bartercancel";

    @Override
    public void handleClientRequest(User sender, ISFSObject params) {
        String barterId = params != null && params.containsKey("barterID")
            ? params.getUtfString("barterID")
            : null;

        if (barterId == null || barterId.isEmpty()) {
            sendError(sender, "INVALID_BARTER", "barterID is required");
            return;
        }

        BarterStore.BarterSession session = BarterServices.getStore().getSession(barterId);
        if (session == null) {
            sendError(sender, "BARTER_NOT_FOUND", "Barter session not found");
            return;
        }

        BarterServices.getStore().removeSession(barterId);

        User initiator = getApi().getUserByName(session.getSenderId());
        User receiver = getApi().getUserByName(session.getReceiverId());
        SFSObject payload = new SFSObject();
        payload.putUtfString("barterID", barterId);
        if (initiator != null) {
            send(COMMAND, payload, initiator);
        }
        if (receiver != null) {
            send(COMMAND, payload, receiver);
        }
    }

    private void sendError(User user, String code, String message) {
        SFSObject error = new SFSObject();
        error.putUtfString("errorCode", code);
        error.putUtfString("message", message);
        send(COMMAND, error, user);
    }
}
