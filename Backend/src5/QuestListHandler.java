package src5;

import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.data.*;

public class QuestListHandler extends OsBaseHandler {
    
    @Override
    public void handleClientRequest(User user, ISFSObject params) {
        trace("[QUESTLIST] Request from: " + user.getName());
        
        SFSObject res = new SFSObject();
        res.putInt("nextRequest", 1000);
        
        SFSArray quests = new SFSArray();
        
        // قائمة المهام كما في السيرفر الرسمي
        quests.addSFSObject(mkQuest(-83095, "cosmicStone", 4, "PERIODIC"));
        quests.addSFSObject(mkQuest(-83096, "sapling_task", 10, "PERIODIC"));
        quests.addSFSObject(mkQuest(-83097, "snowlyFlower", 5, "PERIODIC"));
        quests.addSFSObject(mkQuest(-83098, "snowman", 7, "PERIODIC"));
        quests.addSFSObject(mkQuest(-83099, "paperDelivery", 7, "PERIODIC"));
        quests.addSFSObject(mkQuest(-83100, "GuitarMakingTask", 7, "PERIODIC"));
        quests.addSFSObject(mkQuest(-83101, "trashQuest", 6, "PERIODIC"));
        quests.addSFSObject(mkQuest(-83102, "recycle", 7, "PERIODIC"));
        quests.addSFSObject(mkQuest(-83103, "LegendaryFish", 7, "PERIODIC"));
        quests.addSFSObject(mkQuest(-83104, "PaintersClubQuest", 6, "PERIODIC"));
        quests.addSFSObject(mkQuest(-83105, "besleme", 5, "PERIODIC"));
        
        res.putSFSArray("quests", quests);
        reply(user, "questlist", res);
        
        trace("[QUESTLIST] ✅ Sent " + quests.size() + " quests");
    }
    
    private ISFSObject mkQuest(int id, String metaKey, int totalStep, String type) {
        ISFSObject obj = new SFSObject();
        obj.putInt("id", id);
        obj.putUtfString("metaKey", metaKey);
        obj.putInt("totalStep", totalStep);
        obj.putInt("currentStep", 1);
        obj.putUtfString("status", "NEW");
        obj.putUtfString("type", type);
        obj.putInt("rewardMultiplier", 1);
        return obj;
    }
}