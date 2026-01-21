package src5;

import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.data.*;
import java.util.*;

public class ClothListHandler extends OsBaseHandler {
    
    @Override
    public void handleClientRequest(User user, ISFSObject params) {
        String ip = user.getSession().getAddress();
        
        trace("[CLOTHLIST] ═══════════════════════════════════════════");
        trace("[CLOTHLIST] Request from: " + user.getName() + " IP: " + ip);
        
        // الاستجابة بناءً على التقرير الرسمي
        SFSObject res = new SFSObject();
        
        // نوع الرد - يجب أن يكون "CLOTH" كنص ✅
        res.putUtfString("type", "CLOTH");
        
        // nextRequest - يجب أن يكون 1000 حسب السيرفر الرسمي
        res.putInt("nextRequest", 1000);
        
        // items array
        SFSArray itemsArray = new SFSArray();
        
        // Check if user has saved clothes
        if (getParentExtension().getParentZone().containsProperty(ip + "_clothes")) {
            Object clothesObj = getParentExtension().getParentZone().getProperty(ip + "_clothes");
            
            if (clothesObj != null && clothesObj instanceof ISFSObject) {
                ISFSObject savedClothes = (ISFSObject) clothesObj;
                
                if (savedClothes.containsKey("items")) {
                    ISFSArray savedItems = savedClothes.getSFSArray("items");
                    
                    trace("[CLOTHLIST] Found " + savedItems.size() + " saved items");
                    
                    // Convert each item to match official format
                    for (int i = 0; i < savedItems.size(); i++) {
                        ISFSObject savedItem = savedItems.getSFSObject(i);
                        SFSObject item = createClothItem(savedItem);
                        itemsArray.addSFSObject(item);
                    }
                }
            }
        } else {
            trace("[CLOTHLIST] No saved clothes found for IP: " + ip);
        }
        
        // If no items, create empty array
        if (itemsArray.size() == 0) {
            trace("[CLOTHLIST] Creating empty clothes list");
            itemsArray = new SFSArray();
        }
        
        res.putSFSArray("items", itemsArray);
        
        reply(user, "clothlist", res);
        trace("[CLOTHLIST] ✅ Sent " + itemsArray.size() + " items");
        trace("[CLOTHLIST] ═══════════════════════════════════════════");
    }
    
    private SFSObject createClothItem(ISFSObject savedItem) {
        SFSObject item = new SFSObject();
        
        // استخراج القيم من العنصر المحفوظ
        String clip = savedItem.getUtfString("clip");
        int color = savedItem.getInt("color");
        int quantity = savedItem.getInt("quantity");
        String createdAt = savedItem.getUtfString("createdAt");
        String roles = savedItem.getUtfString("roles");
        int active = savedItem.getInt("active");
        String source = savedItem.getUtfString("source");
        int expire = savedItem.getInt("expire");
        boolean transferrable = savedItem.getBool("transferrable");
        int base = savedItem.getInt("base");
        int productID = savedItem.getInt("productID");
        int id = savedItem.getInt("id");
        String subType = savedItem.getUtfString("subType");
        int lifeTime = savedItem.getInt("lifeTime");
        int timeLeft = savedItem.getInt("timeLeft");
        
        // تعيين القيم - يجب أن تتطابق تماماً مع ما يتوقعه العميل
        item.putUtfString("clip", clip);
        item.putInt("color", color);
        item.putInt("quantity", quantity);
        item.putUtfString("createdAt", createdAt);
        item.putUtfString("roles", roles);
        item.putInt("active", active);
        item.putUtfString("source", source);
        item.putInt("expire", expire);
        item.putBool("transferrable", transferrable);
        item.putInt("base", base);
        item.putInt("productID", productID);
        item.putInt("id", id);
        item.putUtfString("subType", subType);
        item.putInt("lifeTime", lifeTime);
        item.putInt("timeLeft", timeLeft);
        
        return item;
    }
}