package src5;

import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.data.*;

public class ChangeClothesHandler extends OsBaseHandler {
    
    @Override
    public void handleClientRequest(User user, ISFSObject params) {
        trace("[CHANGECLOTHES] " + user.getName() + " changing clothes");
        
        SFSObject res = new SFSObject();
        res.putInt("nextRequest", 4000);
        
        // يجب أيضاً تحديث user variable للـ clothes
        if (params.containsKey("clothes")) {
            ISFSArray clothesArray = params.getSFSArray("clothes");
            trace("[CHANGECLOTHES] Changing to " + clothesArray.size() + " items");
            
            // هنا يمكنك حفظ الملابس المختارة في user variable
            // لكن هذا يحتاج إلى مزيد من التطوير
        }
        
        reply(user, "changeclothes", res);
        trace("[CHANGECLOTHES] ✅ Done");
    }
}