package src5;

import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.data.*;

public class UniverseListHandler extends OsBaseHandler {
    
    @Override
    public void handleClientRequest(User user, ISFSObject params) {
        trace("[UNIVERSELIST] Request from: " + user.getName());
        
        SFSObject res = new SFSObject();
        res.putInt("nextRequest", 1000);
        res.putInt("onlineCount", 82); // عدد اللاعبين المتصلين
        
        SFSArray universes = new SFSArray();
        
        // جزيرة 1 - مفتوحة للجميع
        universes.addSFSObject(mkUniverse("w1", "جزيرة 1", 8, 76, true, true, "AA=="));
        
        // جزيرة VIP - للاعبين المميزين
        universes.addSFSObject(mkUniverse("w8", "كبار الشخصيات", 2, 11, true, false, "2KBGlA=="));
        
        // جزيرة 2
        universes.addSFSObject(mkUniverse("w2", "جزيرة 2", 2, 11, true, false, "AA=="));
        
        res.putSFSArray("universes", universes);
        reply(user, "universelist", res);
        
        trace("[UNIVERSELIST] ✅ Sent " + universes.size() + " universes");
    }
    
    private ISFSObject mkUniverse(String key, String name, int fullness, int roomFullness, 
                                 boolean roomAvailable, boolean recommended, String roles) {
        ISFSObject obj = new SFSObject();
        obj.putUtfString("key", key);
        obj.putUtfString("name", name);
        obj.putInt("fullness", fullness);
        obj.putInt("roomFullness", roomFullness);
        obj.putBool("roomAvailable", roomAvailable);
        obj.putBool("recommended", recommended);
        obj.putUtfString("roles", roles);
        return obj;
    }
}