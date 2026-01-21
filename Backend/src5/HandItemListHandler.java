package src5;

import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.data.*;

public class HandItemListHandler extends OsBaseHandler {
    
    @Override
    public void handleClientRequest(User user, ISFSObject params) {
        trace("[HANDITEMLIST] Request from: " + user.getName());
        
        SFSObject res = new SFSObject();
        
        // كما في السيرفر الرسمي
        res.putInt("pageSelected", 1);
        res.putInt("totalPages", 1);
        res.putInt("nextRequest", 500);
        
        // قائمة العناصر
        SFSObject itemsObj = new SFSObject();
        itemsObj.putInt("page", 1);
        
        SFSArray itemsList = new SFSArray();
        itemsObj.putSFSArray("list", itemsList);
        
        res.putSFSObject("items", itemsObj);
        reply(user, "handitemlist", res);
        
        trace("[HANDITEMLIST] ✅ Response sent");
    }
}