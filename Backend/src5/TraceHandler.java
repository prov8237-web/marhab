package src5;

import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.data.*;

public class TraceHandler extends OsBaseHandler {
    
    @Override
    public void handleClientRequest(User user, ISFSObject params) {
        trace("[TRACE] Request from: " + user.getName());
        
        SFSObject res = new SFSObject();
        reply(user, "trace", res);
        
        trace("[TRACE] ✅ Response sent");
    }
}