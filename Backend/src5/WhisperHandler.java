package src5;

import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.data.*;
import java.util.List;

public class WhisperHandler extends OsBaseHandler {

    @Override
    public void handleClientRequest(User sender, ISFSObject params) {
        trace("[WHISPER] Whisper request from: " + sender.getName());
        
        // الحصول على معاملات الهمس
        String message = params.getUtfString("message");
        String receiverName = params.getUtfString("receiver");
        
        // التحقق من طول الرسالة
        if (message.length() > 100) {
            message = message.substring(0, 100);
        }
        
        // التحقق من الرسالة الفارغة
        if (message.length() < 2) {
            sendError(sender, "EMPTY_MESSAGE");
            return;
        }
        
        // التحقق من صلاحية الهمس
        if (!hasWhisperPermission(sender)) {
            sendError(sender, "INSUFFICIENT_ROLE");
            return;
        }
        
        // البحث عن المستلم
        User receiver = getApi().getUserByName(receiverName);
        
        if (receiver == null) {
            sendError(sender, "USER_NOT_FOUND");
            return;
        }
        
        // التحقق من أن المستلم ليس هو المرسل
        if (receiver.getName().equals(sender.getName())) {
            sendError(sender, "CANNOT_WHISPER_SELF");
            return;
        }
        
        // التحقق من أن المستلم ليس محظوراً
        if (isBlocked(sender, receiver)) {
            sendError(sender, "USER_BLOCKED");
            return;
        }
        
        // إرسال الهمس للمستلم
        sendWhisperToReceiver(sender, receiver, message);
        
        // إرسال إشعار للمرسل أن الهمس تم إرساله
        sendWhisperConfirmation(sender);
        
        // إرسال إشعار للمستخدمين الآخرين في نفس الغرفة
        sendWhisperNotification(sender, receiver);
        
        trace("[WHISPER] ✅ Whisper sent from " + sender.getName() + " to " + receiver.getName());
    }
    
    private boolean hasWhisperPermission(User user) {
        // التحقق من صلاحية WHISPER
        // حسب ملف ConfigHandler، صلاحية WHISPER هي index 4
        if (user.containsVariable("roles")) {
            String roles = user.getVariable("roles").getStringValue();
            // تحليل roles (مشفرة بـ Base64)
            // المهم أن المستخدم لديه صلاحية WHISPER
        }
        return true; // مؤقتاً جميع المستخدمين يمكنهم الهمس
    }
    
    private boolean isBlocked(User sender, User receiver) {
        // التحقق من قائمة الحظر
        // يمكن تخزين قائمة الحظر في متغيرات المستخدم أو في قاعدة البيانات
        return false; // مؤقتاً لا يوجد حظر
    }
    
    private void sendWhisperToReceiver(User sender, User receiver, String message) {
        SFSObject whisperData = new SFSObject();
        whisperData.putUtfString("sender", sender.getName());
        whisperData.putUtfString("receiver", receiver.getName());
        whisperData.putUtfString("message", message);
        whisperData.putInt("chatBalloon", 11); // WHISPER balloon id (من الكلاينت)
        
        send("whisper", whisperData, receiver);
    }
    
    private void sendWhisperConfirmation(User sender) {
        SFSObject confirmation = new SFSObject();
        confirmation.putUtfString("status", "sent");
        
        send("whisperconfirm", confirmation, sender);
    }
    
    private void sendWhisperNotification(User sender, User receiver) {
        // إرسال إشعار للمستخدمين الآخرين في نفس الغرفة
        SFSObject notification = new SFSObject();
        notification.putUtfString("sender", sender.getName());
        notification.putUtfString("receiver", receiver.getName());
        
        // إرسال لكل المستخدمين في الغرفة ما عدا المرسل والمستلم
        List<User> users = getParentExtension().getParentRoom().getUserList();
        
        for (User user : users) {
            if (!user.getName().equals(sender.getName()) && 
                !user.getName().equals(receiver.getName())) {
                send("whispernotify", notification, user);
            }
        }
    }
    
    private void sendError(User user, String errorCode) {
        SFSObject errorResponse = new SFSObject();
        errorResponse.putUtfString("errorCode", errorCode);
        
        send("whispererror", errorResponse, user);
        trace("[WHISPER] ❌ Error: " + errorCode + " for user: " + user.getName());
    }
}