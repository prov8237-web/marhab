package src5;

import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.data.ISFSObject;
import com.smartfoxserver.v2.entities.data.SFSObject;
import com.smartfoxserver.v2.extensions.BaseClientRequestHandler;

public class UserManagementHandler extends BaseClientRequestHandler {
    
    @Override
    public void handleClientRequest(User sender, ISFSObject params) {
        String action = params.containsKey("action") ? params.getUtfString("action") : "info";
        MainExtension ext = (MainExtension) getParentExtension();
        
        if (sender.getPrivilegeId() < 50) {
            sendError(sender, "PERMISSION_DENIED", "Insufficient privileges");
            return;
        }
        
        if (!params.containsKey("targetUser")) {
            sendError(sender, "MISSING_PARAM", "targetUser is required");
            return;
        }
        
        String targetUsername = params.getUtfString("targetUser");
        String reason = params.containsKey("reason") ? params.getUtfString("reason") : "No reason provided";
        int duration = params.containsKey("duration") ? params.getInt("duration") : 0;
        
        switch (action) {
            case "kick":
                kickUser(sender, targetUsername, reason);
                break;
            case "ban":
                banUser(sender, targetUsername, reason, duration);
                break;
            case "mute":
                muteUser(sender, targetUsername, reason, duration);
                break;
            default:
                sendUserInfo(sender, targetUsername);
                break;
        }
    }
    
    private void kickUser(User sender, String targetUsername, String reason) {
        SFSObject response = new SFSObject();
        response.putUtfString("status", "success");
        response.putUtfString("message", "Kick command received for user: " + targetUsername);
        response.putUtfString("reason", reason);
        response.putUtfString("note", "Actual kick functionality requires zone access");
        
        send("kickuser", response, sender);
        ((MainExtension) getParentExtension()).markResponseSent("kickuser", sender);
        
        SystemLogHandler.addLog("KICK", sender.getName() + " requested kick for " + targetUsername + ": " + reason);
    }
    
    private void banUser(User sender, String targetUsername, String reason, int duration) {
        SFSObject response = new SFSObject();
        response.putUtfString("status", "success");
        response.putUtfString("message", "Ban command received for user: " + targetUsername);
        response.putInt("duration", duration);
        response.putUtfString("reason", reason);
        response.putUtfString("note", "Actual ban functionality requires zone access");
        
        send("banuser", response, sender);
        ((MainExtension) getParentExtension()).markResponseSent("banuser", sender);
        
        SystemLogHandler.addLog("BAN", sender.getName() + " requested ban for " + targetUsername + 
                               " for " + duration + " minutes. Reason: " + reason);
    }
    
    private void muteUser(User sender, String targetUsername, String reason, int duration) {
        SFSObject response = new SFSObject();
        response.putUtfString("status", "success");
        response.putUtfString("message", "Mute command received for user: " + targetUsername);
        response.putInt("duration", duration);
        response.putUtfString("reason", reason);
        response.putUtfString("note", "Actual mute functionality requires zone access");
        
        send("muteuser", response, sender);
        ((MainExtension) getParentExtension()).markResponseSent("muteuser", sender);
        
        SystemLogHandler.addLog("MUTE", sender.getName() + " requested mute for " + targetUsername + 
                               " for " + duration + " minutes. Reason: " + reason);
    }
    
    private void sendUserInfo(User sender, String targetUsername) {
        SFSObject response = new SFSObject();
        response.putUtfString("status", "success");
        response.putUtfString("targetUser", targetUsername);
        response.putUtfString("info", "User information request received");
        response.putUtfString("note", "User lookup requires zone access");
        
        send("userinfo", response, sender);
        ((MainExtension) getParentExtension()).markResponseSent("userinfo", sender);
    }
    
    private void sendError(User user, String errorCode, String message) {
        SFSObject error = new SFSObject();
        error.putUtfString("status", "error");
        error.putUtfString("errorCode", errorCode);
        error.putUtfString("message", message);
        // نرسل للـ handler المناسب
        String handlerName = this.getClass().getSimpleName().replace("Handler", "").toLowerCase();
        send(handlerName, error, user);
    }
}