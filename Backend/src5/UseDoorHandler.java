package src5;

import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.data.*;

public class UseDoorHandler extends OsBaseHandler {
    
    @Override
    public void handleClientRequest(User user, ISFSObject params) {
        trace("[USEDOOR] " + user.getName() + " using door");
        
        SFSObject res = new SFSObject();
        res.putInt("nextRequest", 100);
        
        reply(user, "usedoor", res);
        trace("[USEDOOR] ✅ Door used");
    }
}