package src5;

import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.data.*;

public class UseHandItemHandler extends OsBaseHandler {
    
    @Override
    public void handleClientRequest(User user, ISFSObject params) {
        int itemId = params.getInt("id");
        trace("[USEHANDITEM] " + user.getName() + " using hand item ID: " + itemId);
        
        SFSObject res = new SFSObject();
        res.putInt("nextRequest", 1000);
        
        reply(user, "usehanditem", res);
        trace("[USEHANDITEM] ✅ Done");
    }
}