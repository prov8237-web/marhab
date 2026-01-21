package src5;

import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.data.*;

public class RolesHandler extends OsBaseHandler {
    
    @Override
    public void handleClientRequest(User user, ISFSObject params) {
        trace("[ROLES] Request from: " + user.getName());
        
        SFSObject res = new SFSObject();
        res.putUtfString("roles", "AA==");
        reply(user, "roles", res);
        
        trace("[ROLES] ✅ Response sent");
    }
}
