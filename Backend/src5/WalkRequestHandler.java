package src5;

import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.data.*;

public class WalkRequestHandler extends OsBaseHandler {
    
    @Override
    public void handleClientRequest(User user, ISFSObject params) {
        // البيانات تأتي داخل كائن data
        ISFSObject data = params.containsKey("data") ? params.getSFSObject("data") : params;
        
        int x = data.containsKey("x") ? data.getInt("x") : 20;
        int y = data.containsKey("y") ? data.getInt("y") : 20;
        
        trace("[WALKREQUEST] " + user.getName() + " moving to x:" + x + " y:" + y);
        
        SFSObject res = new SFSObject();
        
        // حساب وقت التأخير بناءً على المسافة
        double distance = Math.sqrt(x * x + y * y);
        int delay = (int)(distance * 30); // 30ms لكل بكسل
        
        res.putInt("delay", delay);
        
        reply(user, "walkrequest", res);
        trace("[WALKREQUEST] ✅ Delay: " + delay + "ms");
    }
}