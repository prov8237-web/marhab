package src5;

import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.data.*;

public class BuddyListHandler extends OsBaseHandler {
    
    @Override
    public void handleClientRequest(User user, ISFSObject params) {
        trace("[BUDDYLIST] Request from: " + user.getName());
        
        SFSObject res = new SFSObject();
        
        // Empty buddy list - matching official
        res.putSFSArray("buddies", new SFSArray());
        res.putSFSArray("requests", new SFSArray());
        res.putInt("nextRequest", 10000);  // Official uses 10000 for buddylist
        
        reply(user, "buddylist", res);
        trace("[BUDDYLIST] ✅ Response sent");
    }
}
