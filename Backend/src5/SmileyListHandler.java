package src5;

import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.data.*;

public class SmileyListHandler extends OsBaseHandler {
    
    @Override
    public void handleClientRequest(User user, ISFSObject params) {
        trace("[SMILEYLIST] Request from: " + user.getName());
        
        SFSObject res = new SFSObject();
        res.putInt("nextRequest", 1000);
        
        // قائمة المشاعر كما في السيرفر الرسمي
        SFSArray smilies = new SFSArray();
        
        // إضافة المشاعر بنفس ترتيب السيرفر الرسمي
        smilies.addSFSObject(mkSmiley(1, 0, "empty", "AA=="));
        smilies.addSFSObject(mkSmiley(93, 1, "disco", "AA=="));
        smilies.addSFSObject(mkSmiley(123, 1, "kar_tanesi", "AA=="));
        smilies.addSFSObject(mkSmiley(154, 1, "sanalika", "AA=="));
        smilies.addSFSObject(mkSmiley(245, 1, "LedSnowflake", "AA=="));
        smilies.addSFSObject(mkSmiley(240, 2, "Funwin", "AA=="));
        smilies.addSFSObject(mkSmiley(242, 2, "lifebuoy", "AA=="));
        smilies.addSFSObject(mkSmiley(243, 2, "captainhat", "AAAAAABA"));
        smilies.addSFSObject(mkSmiley(244, 2, "anchor", "AAAAAABA"));
        smilies.addSFSObject(mkSmiley(264, 3, "CafeSmiley", "AAAIAAAAEA=="));
        smilies.addSFSObject(mkSmiley(116, 10, "mutlu", "AA=="));
        smilies.addSFSObject(mkSmiley(117, 11, "lol", "AA=="));
        smilies.addSFSObject(mkSmiley(12, 12, "cool", "AA=="));
        smilies.addSFSObject(mkSmiley(21, 12, "peaceful", "AA=="));
        smilies.addSFSObject(mkSmiley(14, 13, "flirty", "AA=="));
        smilies.addSFSObject(mkSmiley(16, 13, "nervous", "AA=="));
        smilies.addSFSObject(mkSmiley(34, 13, "mutsuz", "AA=="));
        smilies.addSFSObject(mkSmiley(39, 13, "sabit", "AA=="));
        smilies.addSFSObject(mkSmiley(24, 14, "kahraman", "AA=="));
        smilies.addSFSObject(mkSmiley(147, 15, "winking", "AA=="));
        smilies.addSFSObject(mkSmiley(4, 16, "mocking", "AA=="));
        smilies.addSFSObject(mkSmiley(42, 17, "saskin", "AA=="));
        smilies.addSFSObject(mkSmiley(2, 18, "cry", "AA=="));
        smilies.addSFSObject(mkSmiley(36, 19, "olu", "AA=="));
        smilies.addSFSObject(mkSmiley(19, 20, "ill", "AA=="));
        smilies.addSFSObject(mkSmiley(47, 21, "uyku", "AA=="));
        smilies.addSFSObject(mkSmiley(163, 22, "sun", "AA=="));
        smilies.addSFSObject(mkSmiley(13, 23, "storm", "AA=="));
        smilies.addSFSObject(mkSmiley(162, 23, "14subat2", "AA=="));
        smilies.addSFSObject(mkSmiley(27, 24, "kirik_kalp", "AA=="));
        smilies.addSFSObject(mkSmiley(52, 24, "yonca", "AA=="));
        smilies.addSFSObject(mkSmiley(122, 24, "bubbleHeart", "AA=="));
        smilies.addSFSObject(mkSmiley(166, 24, "simit", "CA=="));
        smilies.addSFSObject(mkSmiley(48, 25, "vip", "CA=="));
        smilies.addSFSObject(mkSmiley(87, 25, "diamond", "QA=="));
        smilies.addSFSObject(mkSmiley(91, 25, "diamond1", "ACA="));
        smilies.addSFSObject(mkSmiley(167, 26, "kelebek", "iA=="));
        smilies.addSFSObject(mkSmiley(165, 27, "alev", "AA=="));
        smilies.addSFSObject(mkSmiley(38, 28, "peri", "AA=="));
        smilies.addSFSObject(mkSmiley(33, 29, "melek", "AA=="));
        smilies.addSFSObject(mkSmiley(119, 29, "yildiz_gokkusagi", "CA=="));
        smilies.addSFSObject(mkSmiley(41, 30, "sapka", "AA=="));
        smilies.addSFSObject(mkSmiley(49, 31, "yarasa", "AA=="));
        smilies.addSFSObject(mkSmiley(131, 32, "on_milyon", "AA=="));
        smilies.addSFSObject(mkSmiley(7, 33, "fish", "AA=="));
        smilies.addSFSObject(mkSmiley(31, 35, "kurukafa", "AA=="));
        smilies.addSFSObject(mkSmiley(23, 36, "kagit", "AA=="));
        smilies.addSFSObject(mkSmiley(32, 36, "makas", "AA=="));
        smilies.addSFSObject(mkSmiley(44, 36, "tas", "AA=="));
        smilies.addSFSObject(mkSmiley(199, 37, "snake_1", "AA=="));
        smilies.addSFSObject(mkSmiley(200, 38, "snake_2", "AA=="));
        smilies.addSFSObject(mkSmiley(201, 39, "snake3", "AA=="));
        smilies.addSFSObject(mkSmiley(202, 40, "train", "AA=="));
        smilies.addSFSObject(mkSmiley(203, 41, "train2", "AA=="));
        smilies.addSFSObject(mkSmiley(159, 53, "sanalikaX", "AAAAgA=="));
        smilies.addSFSObject(mkSmiley(5, 54, "goldStar", "EA=="));
        smilies.addSFSObject(mkSmiley(17, 55, "silverStar", "gA=="));
        smilies.addSFSObject(mkSmiley(40, 56, "sanil", "CA=="));
        smilies.addSFSObject(mkSmiley(169, 57, "knight1", "AIA="));
        smilies.addSFSObject(mkSmiley(196, 57, "guide3", "AAAAEA=="));
        smilies.addSFSObject(mkSmiley(218, 57, "director", "AAAE"));
        smilies.addSFSObject(mkSmiley(220, 57, "journalist1", "AAAC"));
        smilies.addSFSObject(mkSmiley(222, 57, "artist2", "AABA"));
        smilies.addSFSObject(mkSmiley(239, 57, "goldCamera", "AAAW"));
        smilies.addSFSObject(mkSmiley(170, 58, "actor", "AAAABA=="));
        smilies.addSFSObject(mkSmiley(227, 58, "music", "AAAAAAAE"));
        smilies.addSFSObject(mkSmiley(104, 110, "nota", "AA=="));
        
        res.putSFSArray("smilies", smilies);
        reply(user, "smileylist", res);
        
        trace("[SMILEYLIST] ✅ Sent " + smilies.size() + " smilies");
    }
    
    private ISFSObject mkSmiley(int id, int sorting, String metaKey, String requirements) {
        ISFSObject obj = new SFSObject();
        obj.putInt("id", id);
        obj.putInt("sorting", sorting);
        obj.putUtfString("metaKey", metaKey);
        obj.putUtfString("requirements", requirements);
        return obj;
    }
}