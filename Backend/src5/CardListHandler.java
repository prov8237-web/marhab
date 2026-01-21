package src5;

import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.data.*;

public class CardListHandler extends OsBaseHandler {
    
    @Override
    public void handleClientRequest(User user, ISFSObject params) {
        trace("[CARDLIST] Request from: " + user.getName());
        
        SFSObject res = new SFSObject();
        
        // كما في السيرفر الرسمي
        res.putUtfString("type", "CARD");
        res.putInt("nextRequest", 1000);
        
        // قائمة بطاقات فارغة
        SFSArray cardsArray = new SFSArray();
        
        res.putSFSArray("items", cardsArray);
        reply(user, "cardlist", res);
        
        trace("[CARDLIST] ✅ Response sent");
    }
}