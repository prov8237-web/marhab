package src5;

import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.data.*;

public class ChatHandler extends OsBaseHandler {
    
    @Override
    public void handleClientRequest(User sender, ISFSObject params) {
        trace("[CHAT] Message from: " + sender.getName());
        
        // الحصول على الرسالة
        String message = params.getUtfString("message");
        long timestamp = params.getLong("ts");
        
        // التحقق من طول الرسالة (مطابق للكلاينت - 100 حرف)
        if (message.length() > 100) {
            message = message.substring(0, 100);
        }
        
        // التحقق من الرسائل المحظورة
        if (isSpamMessage(message)) {
            trace("[CHAT] ❌ Blocked spam message from: " + sender.getName());
            return;
        }
        
        // التحقق من صلاحية المستخدم للشات
        if (!canUserChat(sender)) {
            trace("[CHAT] ❌ User not allowed to chat: " + sender.getName());
            return;
        }
        
        // الحصول على نوع فقاعة الشات للمستخدم
        int chatBalloon = getChatBalloonType(sender);
        
        // إعداد بيانات الرسالة للإرسال للجميع
        SFSObject response = new SFSObject();
        response.putUtfString("sender", sender.getName());
        response.putUtfString("message", message);
        response.putInt("chatBalloon", chatBalloon);
        response.putLong("ts", timestamp);
        
        // إرسال الرسالة للغرفة الحالية - استخدام reply بدلاً من send
        send("publicMessage", response, getParentExtension().getParentRoom().getUserList());
        
        trace("[CHAT] ✅ Message sent by " + sender.getName() + ": " + message);
    }
    
    private boolean isSpamMessage(String message) {
        // التحقق من الرسائل المتكررة
        if (message.length() < 2) {
            return true;
        }
        
        // التحقق من الأحرف المتكررة (8 مرات متتالية كحد أقصى)
        char lastChar = ' ';
        int repeatCount = 1;
        
        for (int i = 0; i < message.length(); i++) {
            char currentChar = message.charAt(i);
            
            if (currentChar == lastChar) {
                repeatCount++;
                if (repeatCount >= 8) {
                    return true; // رسالة سبام
                }
            } else {
                repeatCount = 1;
                lastChar = currentChar;
            }
        }
        
        return false;
    }
    
    private boolean canUserChat(User user) {
        // التحقق من صلاحية المستخدم
        // يمكن التحقق من:
        // 1. صلاحية VIP
        // 2. صلاحية البان
        // 3. صلاحية خاصة للشات
        return true; // مؤقتاً جميع المستخدمين يمكنهم الشات
    }
    
    private int getChatBalloonType(User user) {
        // الحصول على نوع فقاعة الشات من متغيرات المستخدم
        if (user.containsVariable("chatBalloon")) {
            return user.getVariable("chatBalloon").getIntValue();
        }
        
        // الافتراضي هو 1 (فقاعة عادية)
        return 1;
    }
}