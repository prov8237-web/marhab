package src5;

import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.data.*;

public class ChangeSmileyHandler extends OsBaseHandler {
    
    @Override
    public void handleClientRequest(User user, ISFSObject params) {
        trace("[CHANGESMILEY] " + user.getName() + " changing smiley");
        
        // البيانات تأتي داخل كائن data
        ISFSObject data = params.containsKey("data") ? params.getSFSObject("data") : params;
        String key = data.containsKey("key") ? data.getUtfString("key") : "empty";
        
        trace("[CHANGESMILEY] Smiley key: " + key);
        
        SFSObject res = new SFSObject();
        res.putInt("nextRequest", 1000);
        
        reply(user, "changesmiley", res);
        trace("[CHANGESMILEY] ✅ Smiley changed");
    }
}