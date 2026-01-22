package src5;

import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.data.ISFSObject;
import com.smartfoxserver.v2.entities.data.SFSObject;

public class BarterResponseHandler extends OsBaseHandler {
    public static final String COMMAND = "barterresponse";

    @Override
    public void handleClientRequest(User sender, ISFSObject params) {
        String barterId = params != null && params.containsKey("barterID")
            ? params.getUtfString("barterID")
            : null;
        String response = params != null && params.containsKey("response")
            ? params.getUtfString("response")
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

        if (!"ACCEPTED".equalsIgnoreCase(response)) {
            BarterServices.getStore().removeSession(barterId);
            return;
        }

        User initiator = getApi().getUserByName(session.getSenderId());
        User receiver = getApi().getUserByName(session.getReceiverId());
        if (initiator == null || receiver == null) {
            BarterServices.getStore().removeSession(barterId);
            return;
        }

        SFSObject toReceiver = new SFSObject();
        toReceiver.putUtfString("barterID", barterId);
        toReceiver.putUtfString("avatarID", initiator.getName());
        send("barterStarted", toReceiver, receiver);

        SFSObject toInitiator = new SFSObject();
        toInitiator.putUtfString("barterID", barterId);
        toInitiator.putUtfString("avatarID", receiver.getName());
        send("barterStarted", toInitiator, initiator);
    }

    private void sendError(User user, String code, String message) {
        SFSObject error = new SFSObject();
        error.putUtfString("errorCode", code);
        error.putUtfString("message", message);
        send(COMMAND, error, user);
    }
}
