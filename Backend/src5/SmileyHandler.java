package src5;

import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.data.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.HashMap;

public class SmileyHandler extends OsBaseHandler {
    
    private Map<String, SmileyData> smileyCatalog = new HashMap<>();
    
    @Override
    public void handleClientRequest(User user, ISFSObject params) {
        String action = params.getUtfString("action");
        
        trace("[SMILEY] Request from: " + user.getName() + ", action: " + action);
        
        switch (action) {
            case "getList":
                sendSmileyList(user);
                break;
                
            case "useSmiley":
                useSmiley(user, params);
                break;
                
            case "getAvailableSmileys":
                getAvailableSmileys(user);
                break;
                
            case "checkPermission":
                checkSmileyPermission(user, params);
                break;
                
            case "getVersion":
                getSmileyVersion(user, params);
                break;
                
            default:
                trace("[SMILEY] ❌ Unknown action: " + action);
                sendError(user, "UNKNOWN_ACTION");
        }
    }
    
    private void sendSmileyList(User user) {
        trace("[SMILEY] Sending smiley list to: " + user.getName());
        
        // قائمة الوجوه التعبيرية الافتراضية
        initializeDefaultSmileys();
        
        SFSObject response = new SFSObject();
        SFSArray smileyArray = new SFSArray();
        
        for (SmileyData smiley : smileyCatalog.values()) {
            if (userHasPermission(user, smiley)) {
                SFSObject smileyObj = new SFSObject();
                smileyObj.putUtfString("key", smiley.getKey());
                smileyObj.putUtfString("name", smiley.getName());
                smileyObj.putUtfString("path", smiley.getPath());
                smileyObj.putInt("version", smiley.getVersion());
                smileyObj.putUtfString("requirements", smiley.getRequirements());
                smileyObj.putBool("isAnimated", smiley.isAnimated());
                
                smileyArray.addSFSObject(smileyObj);
            }
        }
        
        response.putSFSArray("smileys", smileyArray);
        response.putInt("totalCount", smileyArray.size());
        
        send("smileylist", response, user);
        trace("[SMILEY] ✅ Sent " + smileyArray.size() + " smileys to: " + user.getName());
    }
    
    private void useSmiley(User user, ISFSObject params) {
        String smileyKey = params.getUtfString("smileyKey");
        
        trace("[SMILEY] User " + user.getName() + " wants to use smiley: " + smileyKey);
        
        // التحقق من وجود الوجه التعبيري
        SmileyData smiley = smileyCatalog.get(smileyKey);
        
        if (smiley == null) {
            sendError(user, "SMILEY_NOT_FOUND");
            return;
        }
        
        // التحقق من الصلاحية
        if (!userHasPermission(user, smiley)) {
            sendError(user, "INSUFFICIENT_PERMISSION");
            return;
        }
        
        // التحقق من التبريد (Cooldown)
        if (isOnCooldown(user, smileyKey)) {
            sendError(user, "SMILEY_ON_COOLDOWN");
            return;
        }
        
        // إرسال الوجه التعبيري للغرفة
        broadcastSmileyToRoom(user, smiley);
        
        // تحديث وقت الاستخدام الأخير
        updateLastUsedTime(user, smileyKey);
        
        trace("[SMILEY] ✅ Smiley " + smileyKey + " used by: " + user.getName());
    }
    
    private void getAvailableSmileys(User user) {
        trace("[SMILEY] Getting available smileys for: " + user.getName());
        
        SFSObject response = new SFSObject();
        SFSArray availableSmileys = new SFSArray();
        SFSArray lockedSmileys = new SFSArray();
        
        for (SmileyData smiley : smileyCatalog.values()) {
            SFSObject smileyInfo = new SFSObject();
            smileyInfo.putUtfString("key", smiley.getKey());
            smileyInfo.putUtfString("name", smiley.getName());
            smileyInfo.putUtfString("requirements", smiley.getRequirements());
            
            if (userHasPermission(user, smiley)) {
                availableSmileys.addSFSObject(smileyInfo);
            } else {
                lockedSmileys.addSFSObject(smileyInfo);
            }
        }
        
        response.putSFSArray("available", availableSmileys);
        response.putSFSArray("locked", lockedSmileys);
        
        send("availablesmileys", response, user);
        trace("[SMILEY] ✅ Available smileys sent to: " + user.getName());
    }
    
    private void checkSmileyPermission(User user, ISFSObject params) {
        String smileyKey = params.getUtfString("smileyKey");
        
        SmileyData smiley = smileyCatalog.get(smileyKey);
        
        SFSObject response = new SFSObject();
        response.putUtfString("smileyKey", smileyKey);
        
        if (smiley == null) {
            response.putBool("hasPermission", false);
            response.putUtfString("message", "Smiley not found");
        } else {
            boolean hasPermission = userHasPermission(user, smiley);
            response.putBool("hasPermission", hasPermission);
            
            if (!hasPermission) {
                response.putUtfString("message", smiley.getRequirements());
            }
        }
        
        send("smileypermission", response, user);
    }
    
    private void getSmileyVersion(User user, ISFSObject params) {
        String smileyKey = params.getUtfString("smileyKey");
        
        SmileyData smiley = smileyCatalog.get(smileyKey);
        
        SFSObject response = new SFSObject();
        response.putUtfString("smileyKey", smileyKey);
        
        if (smiley != null) {
            response.putInt("version", smiley.getVersion());
            response.putUtfString("path", smiley.getPath());
        } else {
            response.putInt("version", 0);
        }
        
        send("smileyversion", response, user);
    }
    
    private void broadcastSmileyToRoom(User user, SmileyData smiley) {
        SFSObject smileyEvent = new SFSObject();
        smileyEvent.putUtfString("sender", user.getName());
        smileyEvent.putUtfString("smileyKey", smiley.getKey());
        smileyEvent.putUtfString("smileyName", smiley.getName());
        smileyEvent.putLong("timestamp", System.currentTimeMillis());
        
        // إرسال للجميع في الغرفة
        send("smileyused", smileyEvent, getParentExtension().getParentRoom().getUserList());
    }
    
    private boolean userHasPermission(User user, SmileyData smiley) {
        // التحقق من صلاحيات المستخدم
        // يمكن التحقق من:
        // 1. صلاحيات VIP
        // 2. مستوى المستخدم
        // 3. إنجازات معينة
        
        // مؤقتاً، جميع المستخدمين يمكنهم استخدام الوجوه التعبيرية الأساسية
        return !smiley.getRequirements().contains("VIP") && 
               !smiley.getRequirements().contains("DIAMOND");
    }
    
    private boolean isOnCooldown(User user, String smileyKey) {
        // التحقق من التبريد
        // يمكن تخزين وقت الاستخدام الأخير في متغيرات المستخدم
        return false; // مؤقتاً لا يوجد تبريد
    }
    
    private void updateLastUsedTime(User user, String smileyKey) {
        // تحديث وقت الاستخدام الأخير
        // يمكن تخزينه في متغيرات المستخدم
    }
    
    private void initializeDefaultSmileys() {
        if (!smileyCatalog.isEmpty()) {
            return; // تم التهيئة مسبقاً
        }
        
        // إضافة الوجوه التعبيرية الافتراضية
        addSmiley("smile", "Smile", "expressions/smile.swf", 1, "AA==");
        addSmiley("wink", "Wink", "expressions/wink.swf", 1, "AA==");
        addSmiley("laugh", "Laugh", "expressions/laugh.swf", 1, "AA==");
        addSmiley("sad", "Sad", "expressions/sad.swf", 1, "AA==");
        addSmiley("angry", "Angry", "expressions/angry.swf", 1, "AA==");
        addSmiley("surprised", "Surprised", "expressions/surprised.swf", 1, "AA==");
        addSmiley("cool", "Cool", "expressions/cool.swf", 1, "gA=="); // يحتاج لصلاحية
        addSmiley("vip_smile", "VIP Smile", "expressions/vip_smile.swf", 1, "QA=="); // VIP only
        addSmiley("diamond_smile", "Diamond Smile", "expressions/diamond_smile.swf", 2, "ACA="); // Diamond Club
    }
    
    private void addSmiley(String key, String name, String path, int version, String requirements) {
        SmileyData smiley = new SmileyData(key, name, path, version, requirements);
        smileyCatalog.put(key, smiley);
    }
    
    private void sendError(User user, String error) {
        SFSObject errorResponse = new SFSObject();
        errorResponse.putUtfString("error", error);
        
        send("smileyerror", errorResponse, user);
        trace("[SMILEY] ❌ Error: " + error + " for user: " + user.getName());
    }
    
    // فئة مساعدة لبيانات الوجه التعبيري
    private class SmileyData {
        private String key;
        private String name;
        private String path;
        private int version;
        private String requirements;
        private boolean isAnimated;
        
        public SmileyData(String key, String name, String path, int version, String requirements) {
            this.key = key;
            this.name = name;
            this.path = path;
            this.version = version;
            this.requirements = requirements;
            this.isAnimated = path.contains("animated");
        }
        
        public String getKey() { return key; }
        public String getName() { return name; }
        public String getPath() { return path; }
        public int getVersion() { return version; }
        public String getRequirements() { return requirements; }
        public boolean isAnimated() { return isAnimated; }
    }
}