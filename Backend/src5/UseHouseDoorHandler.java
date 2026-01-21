package src5;

import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.data.*;

public class UseHouseDoorHandler extends OsBaseHandler {
    
    @Override
    public void handleClientRequest(User user, ISFSObject params) {
        trace("[USEHOUSEDOOR] " + user.getName() + " using house door");
        
        SFSObject res = new SFSObject();
        res.putInt("nextRequest", 100);
        
        reply(user, "usehousedoor", res);
        trace("[USEHOUSEDOOR] ✅ House door used");
    }
}