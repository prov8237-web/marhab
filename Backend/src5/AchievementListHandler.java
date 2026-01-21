package src5;

import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.data.*;

public class AchievementListHandler extends OsBaseHandler {
    
    @Override
    public void handleClientRequest(User user, ISFSObject params) {
        trace("[ACHIEVEMENTLIST] Request from: " + user.getName());
        
        SFSObject res = new SFSObject();
        res.putInt("nextRequest", 1000);
        
        // قائمة الإنجازات كما في السيرفر الرسمي
        SFSArray achievements = new SFSArray();
        
        // Quest Mania Achievement
        achievements.addSFSObject(mkAchievement(5004180, "questmania", 3, 1, "ONGOING", "ACHIEVEMENT"));
        
        // Payment Sanil Achievement
        achievements.addSFSObject(mkAchievement(5004181, "paymentSanil", 3, 1, "ONGOING", "ACHIEVEMENT"));
        
        // Spend Diamond Achievement
        achievements.addSFSObject(mkAchievement(5004182, "spendDiamond", 3, 1, "ONGOING", "ACHIEVEMENT"));
        
        // Payment VIP Achievement
        achievements.addSFSObject(mkAchievement(5004183, "paymentVIP", 3, 1, "ONGOING", "ACHIEVEMENT"));
        
        // Catch Fish Achievement
        achievements.addSFSObject(mkAchievement(5004184, "catchFish", 3, 1, "ONGOING", "ACHIEVEMENT"));
        
        // Payment Diamond Achievement
        achievements.addSFSObject(mkAchievement(5004185, "paymentDiamond", 3, 1, "ONGOING", "ACHIEVEMENT"));
        
        // Game Ship Achievement
        achievements.addSFSObject(mkAchievement(-83093, "gameShip", 3, 1, "ONGOING", "ACHIEVEMENT"));
        
        // Game Farm Achievement
        achievements.addSFSObject(mkAchievement(-83094, "gameFarm", 3, 1, "ONGOING", "ACHIEVEMENT"));
        
        res.putSFSArray("achievements", achievements);
        reply(user, "achievementlist", res);
        
        trace("[ACHIEVEMENTLIST] ✅ Sent " + achievements.size() + " achievements");
    }
    
    private ISFSObject mkAchievement(int id, String metaKey, int totalStep, int currentStep, String status, String type) {
        ISFSObject obj = new SFSObject();
        obj.putInt("id", id);
        obj.putUtfString("metaKey", metaKey);
        obj.putInt("totalStep", totalStep);
        obj.putInt("currentStep", currentStep);
        obj.putUtfString("status", status);
        obj.putUtfString("type", type);
        obj.putInt("rewardMultiplier", 1);
        
        // إنشاء مصفوفة فارغة للخطوات (يمكن تطويرها لاحقاً)
        SFSArray steps = new SFSArray();
        obj.putSFSArray("steps", steps);
        obj.putSFSArray("rewardSteps", new SFSArray());
        
        return obj;
    }
}