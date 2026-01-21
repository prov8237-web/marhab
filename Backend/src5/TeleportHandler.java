package src5;

import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.data.*;

public class TeleportHandler extends OsBaseHandler {
    
    @Override
    public void handleClientRequest(User user, ISFSObject params) {
        trace("[TELEPORT] " + user.getName() + " teleporting");
        
        SFSObject res = new SFSObject();
        res.putInt("nextRequest", 100);
        
        reply(user, "teleport", res);
        trace("[TELEPORT] ✅ Teleport handled");
    }
}