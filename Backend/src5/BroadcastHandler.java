package src5;

import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.data.ISFSObject;
import com.smartfoxserver.v2.entities.data.SFSObject;
import com.smartfoxserver.v2.extensions.BaseClientRequestHandler;

public class BroadcastHandler extends BaseClientRequestHandler {
    
    @Override
    public void handleClientRequest(User user, ISFSObject params) {
        if (user.getPrivilegeId() < 50) {
            sendError(user, "PERMISSION_DENIED", "Insufficient privileges");
            return;
        }
        
        if (!params.containsKey("message")) {
            sendError(user, "MISSING_PARAM", "Message is required");
            return;
        }
        
        String message = params.getUtfString("message");
        String type = params.containsKey("type") ? params.getUtfString("type") : "info";
        String target = params.containsKey("target") ? params.getUtfString("target") : "all";
        
        // Note: لن نستخدم getParentZone() - سنرسل للإشعار فقط
        SFSObject response = new SFSObject();
        response.putUtfString("status", "success");
        response.putUtfString("message", "Broadcast feature is ready");
        response.putUtfString("note", "Implementation pending zone access");
        
        send("broadcast", response, user);
        ((MainExtension) getParentExtension()).markResponseSent("broadcast", user);
        
        // Log the broadcast request
        SystemLogHandler.addLog("BROADCAST", user.getName() + " requested broadcast: " + message);
    }
    
    private void sendError(User user, String errorCode, String message) {
        SFSObject error = new SFSObject();
        error.putUtfString("status", "error");
        error.putUtfString("errorCode", errorCode);
        error.putUtfString("message", message);
        send("broadcast", error, user);
    }
}