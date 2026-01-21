package src5;

import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.data.*;
import com.smartfoxserver.v2.entities.variables.*;
import java.util.*;

public class BuddySystemHandler extends OsBaseHandler {
    
    private Map<String, List<BuddyData>> buddyLists = new HashMap<>();
    private Map<String, List<BuddyRequestData>> buddyRequests = new HashMap<>();
    
    @Override
    public void handleClientRequest(User user, ISFSObject params) {
        String userName = user.getName();
        
        trace("[BUDDYSYSTEM] Command from: " + userName);
        
        // التحقق من الأمر وتنفيذه
        String command = getRequestId();
        
        if (command == null) {
            trace("❌ ERROR: No requestId set!");
            return;
        }
        
        switch(command) {
            case "addbuddy":
                handleAddBuddy(user, params);
                break;
            case "removebuddy":
                handleRemoveBuddy(user, params);
                break;
            case "buddylocate":
                handleBuddyLocate(user, params);
                break;
            case "buddyinvitelocation":
                handleBuddyInviteLocation(user, params);
                break;
            case "buddyrespondinvitelocation":
                handleBuddyRespondInviteLocation(user, params);
                break;
            case "buddyacceptinvitegame":
                handleBuddyAcceptInviteGame(user, params);
                break;
            case "changemood":
                handleChangeMood(user, params);
                break;
            case "changestatusmessage":
                handleChangeStatusMessage(user, params);
                break;
            case "changebuddyrating":
                handleChangeBuddyRating(user, params);
                break;
            case "addbuddyresponse":
                handleAddBuddyResponse(user, params);
                break;
            default:
                trace("[BUDDYSYSTEM] ⚠️ Unknown command: " + command);
                SFSObject errorRes = new SFSObject();
                errorRes.putUtfString("errorCode", "UNKNOWN_COMMAND");
                reply(user, errorRes);
        }
    }
    
    // ============== IMPLEMENTATIONS ==============
    
    private void handleAddBuddy(User user, ISFSObject params) {
        String targetAvatarID = params.getUtfString("avatarID");
        String senderName = user.getName();
        
        trace("[ADDBUDDY] " + senderName + " → " + targetAvatarID);
        
        // التحقق من عدم وجود الطلب مسبقاً
        List<BuddyRequestData> targetRequests = buddyRequests.getOrDefault(targetAvatarID, new ArrayList<>());
        boolean requestExists = false;
        
        for (BuddyRequestData req : targetRequests) {
            if (req.senderID.equals(senderName)) {
                requestExists = true;
                break;
            }
        }
            
        if (!requestExists) {
            // إضافة طلب جديد
            BuddyRequestData newRequest = new BuddyRequestData();
            newRequest.senderID = senderName;
            newRequest.avatarName = senderName;
            newRequest.timestamp = System.currentTimeMillis();
            
            targetRequests.add(newRequest);
            buddyRequests.put(targetAvatarID, targetRequests);
            
            trace("[ADDBUDDY] ✅ Request sent");
            
            SFSObject res = new SFSObject();
            res.putBool("success", true);
            reply(user, res);
        } else {
            trace("[ADDBUDDY] ⚠️ Request already exists");
            SFSObject errorRes = new SFSObject();
            errorRes.putUtfString("errorCode", "REQUEST_ALREADY_EXISTS");
            reply(user, errorRes);
        }
    }
    
    private void handleRemoveBuddy(User user, ISFSObject params) {
        String targetAvatarID = params.getUtfString("avatarID");
        String userName = user.getName();
        
        trace("[REMOVEBUDDY] " + userName + " removing: " + targetAvatarID);
        
        SFSObject res = new SFSObject();
        res.putBool("success", true);
        reply(user, res);
    }
    
    private void handleBuddyLocate(User user, ISFSObject params) {
        String targetAvatarID = params.getUtfString("avatarID");
        trace("[BUDDYLOCATE] Locating: " + targetAvatarID);
        
        SFSObject res = new SFSObject();
        res.putUtfString("universe", "w1");
        res.putUtfString("street", "street01");
        res.putBool("isOnline", true);
        
        reply(user, res);
    }
    
    private void handleBuddyInviteLocation(User user, ISFSObject params) {
        trace("[BUDDYINVITE] Location invite");
        SFSObject res = new SFSObject();
        res.putBool("success", true);
        reply(user, res);
    }
    
    private void handleBuddyRespondInviteLocation(User user, ISFSObject params) {
        trace("[BUDDYRESPONDINVITE] Respond to location invite");
        SFSObject res = new SFSObject();
        res.putBool("success", true);
        reply(user, res);
    }
    
    private void handleBuddyAcceptInviteGame(User user, ISFSObject params) {
        trace("[BUDDYACCEPTGAME] Accept game invite");
        SFSObject res = new SFSObject();
        res.putBool("success", true);
        reply(user, res);
    }
    
    private void handleChangeMood(User user, ISFSObject params) {
        int moodID = params.getInt("mood");
        trace("[CHANGEMOOD] Mood changed to: " + moodID);
        
        // تحديث متغير المستخدم
        List<UserVariable> userVars = new ArrayList<>();
        userVars.add(new SFSUserVariable("mood", moodID));
        getApi().setUserVariables(user, userVars);
        
        SFSObject res = new SFSObject();
        res.putBool("success", true);
        reply(user, res);
    }
    
    private void handleChangeStatusMessage(User user, ISFSObject params) {
        String message = params.getUtfString("message");
        trace("[STATUSMSG] Status changed: " + message);
        
        SFSObject res = new SFSObject();
        res.putBool("success", true);
        reply(user, res);
    }
    
    private void handleChangeBuddyRating(User user, ISFSObject params) {
        String avatarID = params.getUtfString("avatarID");
        int rating = params.getInt("rating");
        trace("[BUDDYRATING] Rating " + avatarID + ": " + rating);
        
        SFSObject res = new SFSObject();
        res.putBool("success", true);
        reply(user, res);
    }
    
    private void handleAddBuddyResponse(User user, ISFSObject params) {
        String avatarID = params.getUtfString("avatarID");
        String response = params.getUtfString("response");
        trace("[BUDDYRESPONSE] Response to " + avatarID + ": " + response);
        
        SFSObject res = new SFSObject();
        res.putBool("success", true);
        reply(user, res);
    }
    
    // ============== HELPER CLASSES ==============
    
    class BuddyData {
        String avatarID;
        String avatarName;
        boolean isOnline;
        int mood;
        String imgPath;
        String status;
    }
    
    class BuddyRequestData {
        String senderID;
        String avatarName;
        long timestamp;
    }
}