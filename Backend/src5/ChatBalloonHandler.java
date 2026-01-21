package src5;

import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.data.*;

public class ChatBalloonHandler extends OsBaseHandler {

    @Override
    public void handleClientRequest(User user, ISFSObject params) {
        trace("[CHATBALLOON] Request from: " + user.getName());
        
        // إرسال قائمة فقاعات الشات المتاحة
        SFSObject response = new SFSObject();
        SFSArray balloons = new SFSArray();
        
        // إضافة فقاعات الشات (مطابق لملف ConfigHandler)
        balloons.addSFSObject(createBalloon(1, "Default", "AA=="));
        balloons.addSFSObject(createBalloon(2, "Blue", "gA=="));
        balloons.addSFSObject(createBalloon(3, "Yellow", "EA=="));
        balloons.addSFSObject(createBalloon(4, "Grey", "QA=="));
        balloons.addSFSObject(createBalloon(23, "Black", "QA=="));
        balloons.addSFSObject(createBalloon(24, "Red", "EA=="));
        balloons.addSFSObject(createBalloon(25, "Pink", "EA=="));
        balloons.addSFSObject(createBalloon(26, "DiamondClub", "ACA="));
        balloons.addSFSObject(createBalloon(30, "SanalikaX", "AAAAgA=="));
        
        response.putSFSArray("chatBalloons", balloons);
        
        // إرسال قوالب الألوان (ChatColorTemplate)
        SFSArray colorTemplates = new SFSArray();
        
        // Default
        SFSObject defaultTemplate = new SFSObject();
        defaultTemplate.putInt("id", 1);
        defaultTemplate.putInt("textColor", 6118749);
        defaultTemplate.putInt("boxColor", 16711666);
        defaultTemplate.putUtfString("name", "Default Bubble");
        colorTemplates.addSFSObject(defaultTemplate);
        
        // Blue
        SFSObject blueTemplate = new SFSObject();
        blueTemplate.putInt("id", 6); // Note: BLUE has id 6 in ChatColorTemplate
        blueTemplate.putInt("textColor", 16777215);
        blueTemplate.putInt("boxColor", 3394713);
        blueTemplate.putUtfString("name", "Blue Bubble");
        colorTemplates.addSFSObject(blueTemplate);
        
        // Yellow
        SFSObject yellowTemplate = new SFSObject();
        yellowTemplate.putInt("id", 3);
        yellowTemplate.putInt("textColor", 6118749);
        yellowTemplate.putInt("boxColor", 16631612);
        yellowTemplate.putUtfString("name", "Yellow Bubble");
        colorTemplates.addSFSObject(yellowTemplate);
        
        // Whisper (مهم للهمس)
        SFSObject whisperTemplate = new SFSObject();
        whisperTemplate.putInt("id", 11);
        whisperTemplate.putInt("textColor", 16777215);
        whisperTemplate.putInt("boxColor", 12177472);
        whisperTemplate.putUtfString("name", "Whisper Bubble");
        colorTemplates.addSFSObject(whisperTemplate);
        
        // Diamond Club
        SFSObject diamondTemplate = new SFSObject();
        diamondTemplate.putInt("id", 26);
        diamondTemplate.putInt("textColor", 16777215);
        diamondTemplate.putInt("boxColor", 3355443);
        diamondTemplate.putUtfString("name", "Diamond Club Bubble");
        colorTemplates.addSFSObject(diamondTemplate);
        
        response.putSFSArray("colorTemplates", colorTemplates);
        
        send("chatballoonlist", response, user);
        trace("[CHATBALLOON] ✅ Sent " + balloons.size() + " balloons and " + 
              colorTemplates.size() + " color templates");
    }
    
    private ISFSObject createBalloon(int id, String name, String requirements) {
        SFSObject balloon = new SFSObject();
        balloon.putInt("id", id);
        balloon.putUtfString("name", name);
        balloon.putUtfString("requirements", requirements);
        return balloon;
    }
}