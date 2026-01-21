package src5;

import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.data.*;
import com.smartfoxserver.v2.entities.variables.*;
import java.util.*;

public class SaveBaseClothesHandler extends OsBaseHandler {
    
    @Override
    public void handleClientRequest(User user, ISFSObject params) {
        String ip = user.getSession().getAddress();
        
        trace("[SAVEBASECLOTHES] ═══════════════════════════════════════════");
        trace("[SAVEBASECLOTHES] Request from: " + user.getName() + " IP: " + ip);
        
        // التحقق من هيكل البيانات
        trace("[SAVEBASECLOTHES] Params keys: " + params.getKeys());
        
        // في السيرفر الرسمي، البيانات تأتي في params مباشرة، ليس داخل "data"
        ISFSObject dataObj = params;
        
        // إذا كان هناك مفتاح "data" نستخدمه، وإلا نستخدم params مباشرة
        if (params.containsKey("data")) {
            dataObj = params.getSFSObject("data");
            trace("[SAVEBASECLOTHES] Using 'data' object from params");
        } else {
            trace("[SAVEBASECLOTHES] No 'data' key, using params directly");
        }
        
        // استخراج البيانات
        String avatarName = dataObj.containsKey("avatarName") ? dataObj.getUtfString("avatarName") : "Guest";
        String gender = dataObj.containsKey("gender") ? dataObj.getUtfString("gender") : "m";
        
        trace("[SAVEBASECLOTHES] Avatar: " + avatarName + ", Gender: " + gender);
        
        // بناء كائن الملابس للتخزين
        SFSObject clothesObj = new SFSObject();
        clothesObj.putUtfString("type", "CLOTH");
        SFSArray items = new SFSArray();

        if (dataObj.containsKey("clothes")) {
            ISFSArray chosen = dataObj.getSFSArray("clothes");
            trace("[SAVEBASECLOTHES] Processing " + chosen.size() + " items...");
            
            for (int i = 0; i < chosen.size(); i++) {
                ISFSObject row = chosen.getSFSObject(i);
                SFSObject item = new SFSObject();
                
                // استخراج القيم مع التحقق من وجودها
                String clip = row.containsKey("clip") ? row.getUtfString("clip") : "";
                String colorStr = row.containsKey("color") ? row.getUtfString("color") : "1";
                
                if (clip.isEmpty()) {
                    trace("[SAVEBASECLOTHES] WARNING: Empty clip at index " + i);
                    continue;
                }
                
                int color = 1;
                try {
                    color = Integer.parseInt(colorStr);
                } catch (NumberFormatException e) {
                    trace("[SAVEBASECLOTHES] WARNING: Invalid color: " + colorStr + ", using default 1");
                }
                
                int productID = getProductIDByClip(clip);
                String subType = getSubTypeByClip(clip);
                
                trace("[SAVEBASECLOTHES] Item " + i + ": clip=" + clip + ", color=" + color + ", productID=" + productID);
                
                // توليد ID فريد
                int uniqueID = (int)(Math.random() * 1000000000) + 100000000;
                
                // بناء العنصر بنفس هيكل السيرفر الرسمي
                item.putInt("quantity", 1);
                item.putInt("color", color);
                item.putUtfString("createdAt", System.currentTimeMillis() + "");
                item.putUtfString("roles", "AA==");
                item.putInt("active", 1);
                item.putUtfString("source", "FREE");
                item.putInt("expire", 0);
                item.putBool("transferrable", false);
                item.putInt("base", 1);
                item.putInt("productID", productID);
                item.putInt("id", uniqueID);
                item.putUtfString("subType", subType);
                item.putInt("lifeTime", 0);
                item.putUtfString("clip", clip + "_" + color); // ✅ تصحيح: clip_color بدون Str
                item.putInt("timeLeft", 0);
                
                items.addSFSObject(item);
            }
        } else {
            trace("[SAVEBASECLOTHES] WARNING: No 'clothes' key in data!");
        }
        
        clothesObj.putSFSArray("items", items);
        trace("[SAVEBASECLOTHES] Total items to save: " + items.size());

        // الحفظ في Zone Properties
        getParentExtension().getParentZone().setProperty(ip + "_active", Boolean.TRUE);
        getParentExtension().getParentZone().setProperty(ip + "_clothes", clothesObj);
        getParentExtension().getParentZone().setProperty(ip + "_name", avatarName);
        getParentExtension().getParentZone().setProperty(ip + "_gender", gender);
        
        // التحقق من الحفظ
        trace("[SAVEBASECLOTHES] Verifying save...");
        Object savedClothes = getParentExtension().getParentZone().getProperty(ip + "_clothes");
        if (savedClothes != null && savedClothes instanceof ISFSObject) {
            ISFSObject sc = (ISFSObject) savedClothes;
            if (sc.containsKey("items")) {
                trace("[SAVEBASECLOTHES] ✅ Verified: " + sc.getSFSArray("items").size() + " items saved");
                // طباعة عنصر واحد للتحقق
                if (sc.getSFSArray("items").size() > 0) {
                    trace("[SAVEBASECLOTHES] Sample item: " + sc.getSFSArray("items").getSFSObject(0).toJson());
                }
            }
        }
        
        // إرسال الاستجابة
        SFSObject res = new SFSObject();
        res.putInt("nextRequest", 1000);
        reply(user, "savebaseclothes", res);
        
        trace("[SAVEBASECLOTHES] ✅ Complete");
        trace("[SAVEBASECLOTHES] ═══════════════════════════════════════════");
    }

    private int getProductIDByClip(String clip) {
        // إضافة المزيد من القيم
        switch (clip.toUpperCase()) {
            case "C": return 1349;
            case "B": return 1348;
            case "A": return 1344;
            case "7": return 31;
            case "1": return 2;
            case "4": return 149;
            case "9": return 33;
            case "10": return 3;
            case "11": return 4;
            case "12": return 5;
            case "13": return 6;
            case "3": return 20;
            case "5": return 21; // ✅ إضافة الـ 5
            case "6": return 30;
            case "8": return 32;
            case "2": return 136;
            default: return 0;
        }
    }

    private String getSubTypeByClip(String clip) {
        String c = clip.toUpperCase();
        
        if (c.equals("10") || c.equals("11") || c.equals("12") || c.equals("13") || 
            c.equals("3") || c.equals("8") || c.equals("9")) {
            return "HAIR";
        }
        if (c.equals("7") || c.equals("6")) {
            return "SHOES";
        }
        if (c.equals("1") || c.equals("4") || c.equals("5")) {
            return "SHIRT";
        }
        if (c.equals("2")) {
            return "PANTS";
        }
        
        return "BODY";
    }
}