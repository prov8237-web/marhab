package src5;

import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.data.*;

public class ProfileHandler extends OsBaseHandler {
    
    @Override
    public void handleClientRequest(User user, ISFSObject params) {
        String avatarID = params.getUtfString("avatarID");
        trace("[PROFILE] Request for avatarID: " + avatarID);
        
        SFSObject res = new SFSObject();
        res.putInt("nextRequest", 500);
        
        // بيانات الملف الشخصي كما في السيرفر الرسمي
        res.putUtfString("avatarName", getAvatarName(avatarID));
        res.putInt("avatarAge", 0); // يمكن حساب العمر من تاريخ الإنشاء
        res.putInt("duration", 0);
        res.putInt("emailRegistered", 0);
        res.putUtfString("avarageRating", "0.00");
        res.putInt("likeCount", 0);
        res.putInt("dislikeCount", 0);
        res.putInt("banCount", 0);
        res.putInt("totalBuddies", 0);
        res.putBool("isBuddy", false);
        res.putBool("isRequest", false);
        res.putUtfString("status", "");
        res.putUtfString("runWinTeam", "");
        res.putInt("mood", 0);
        
        // الباجات (Badges)
        SFSArray badges = new SFSArray();
        res.putSFSArray("badges", badges);
        
        // البطاقات (Cards)
        SFSArray cards = new SFSArray();
        res.putSFSArray("cards", cards);
        
        // الملصقات (Stickers)
        SFSArray stickers = new SFSArray();
        res.putSFSArray("stickers", stickers);
        
        // الشقق (Flats)
        SFSArray flats = new SFSArray();
        res.putSFSArray("flats", flats);
        
        reply(user, "profile", res);
        trace("[PROFILE] ✅ Profile sent for avatar: " + avatarID);
    }
    
    private String getAvatarName(String avatarID) {
        // يمكن استرجاع الاسم من قاعدة البيانات أو Zone Properties
        // حالياً نرجع اسم افتراضي
        return "Player" + avatarID.substring(0, 6);
    }
}