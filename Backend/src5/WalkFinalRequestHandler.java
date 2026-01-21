package src5;

import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.data.*;

public class WalkFinalRequestHandler extends OsBaseHandler {
    
    @Override
    public void handleClientRequest(User user, ISFSObject params) {
        trace("[WALKFINALREQUEST] " + user.getName() + " finished walking");
        
        SFSObject res = new SFSObject();
        res.putInt("nextRequest", 100);
        
        reply(user, "walkfinalrequest", res);
        trace("[WALKFINALREQUEST] ✅ Done");
    }
}