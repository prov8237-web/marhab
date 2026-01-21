package src5;

import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.data.*;

public class ChatExtensions extends OsBaseHandler {

    @Override
    public void handleClientRequest(User user, ISFSObject params) {
        trace("[CHATEXT] Request from: " + user.getName());
        
        String action = params.getUtfString("action");
        
        switch(action) {
            case "getSettings":
                sendChatSettings(user);
                break;
                
            case "updateSettings":
                updateChatSettings(user, params);
                break;
                
            case "reportUser":
                reportUser(user, params);
                break;
                
            case "blockUser":
                blockUser(user, params);
                break;
                
            default:
                trace("[CHATEXT] ❌ Unknown action: " + action);
                sendError(user, "UNKNOWN_ACTION");
        }
    }
    
    private void sendChatSettings(User user) {
        SFSObject settings = new SFSObject();
        settings.putBool("incomingMessages", true);
        settings.putBool("chatSounds", true);
        settings.putBool("whisperNotifications", true);
        settings.putInt("maxHistory", 50); // مطابق للكلاينت
        
        send("chatsettings", settings, user);
    }
    
    private void updateChatSettings(User user, ISFSObject params) {
        boolean incomingMessages = params.getBool("incomingMessages");
        boolean chatSounds = params.getBool("chatSounds");
        boolean whisperNotifications = params.getBool("whisperNotifications");
        
        // حفظ الإعدادات للمستخدم
        // يمكن حفظها في متغيرات المستخدم أو قاعدة البيانات
        
        SFSObject response = new SFSObject();
        response.putUtfString("status", "updated");
        send("settingsupdated", response, user);
        
        trace("[CHATEXT] ✅ Chat settings updated for: " + user.getName());
    }
    
    private void reportUser(User reporter, ISFSObject params) {
        String reportedUserId = params.getUtfString("reportedUser");
        String lastMessage = params.getUtfString("lastMessage");
        String reason = params.getUtfString("reason");
        
        trace("[CHATEXT] 🚨 User report: " + reporter.getName() + 
              " reported " + reportedUserId + " for: " + reason);
        
        // هنا يمكنك:
        // 1. حفظ البلاغ في قاعدة البيانات
        // 2. إرسال إشعار للإدارة
        // 3. تسجيل الحدث
        
        SFSObject response = new SFSObject();
        response.putUtfString("status", "reported");
        response.putUtfString("message", "Thank you for your report. We will review it.");
        
        send("reportresponse", response, reporter);
    }
    
    private void blockUser(User user, ISFSObject params) {
        String userIdToBlock = params.getUtfString("userId");
        
        // إضافة المستخدم لقائمة الحظر
        // يمكن تخزينها في متغيرات المستخدم
        
        trace("[CHATEXT] 🔒 User blocked: " + user.getName() + 
              " blocked " + userIdToBlock);
        
        SFSObject response = new SFSObject();
        response.putUtfString("status", "blocked");
        
        send("blockresponse", response, user);
    }
    
    private void sendError(User user, String error) {
        SFSObject errorResponse = new SFSObject();
        errorResponse.putUtfString("error", error);
        
        send("chaterror", errorResponse, user);
    }
}