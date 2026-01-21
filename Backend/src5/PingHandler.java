package src5;

import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.data.*;

public class PingHandler extends OsBaseHandler {
    
    @Override
    public void handleClientRequest(User user, ISFSObject params) {
        // Official server responds to "ping" with "pong" command
        SFSObject res = new SFSObject();
        send("pong", res, user);
        trace("[PING] Sent pong to " + user.getName());
    }
}
