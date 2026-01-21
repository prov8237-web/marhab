package src5;

import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.data.*;

public class UseObjectDoorHandler extends OsBaseHandler {
    
    @Override
    public void handleClientRequest(User user, ISFSObject params) {
        trace("[USEOBJECTDOOR] " + user.getName() + " using object door");
        
        SFSObject res = new SFSObject();
        res.putInt("nextRequest", 100);
        
        reply(user, "useobjectdoor", res);
        trace("[USEOBJECTDOOR] ✅ Object door used");
    }
}