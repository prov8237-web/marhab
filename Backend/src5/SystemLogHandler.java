package src5;

import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.data.ISFSObject;
import com.smartfoxserver.v2.entities.data.SFSArray;
import com.smartfoxserver.v2.entities.data.SFSObject;
import com.smartfoxserver.v2.extensions.BaseClientRequestHandler;
import java.util.ArrayList;
import java.util.List;

public class SystemLogHandler extends BaseClientRequestHandler {
    
    private static List<String> systemLogs = new ArrayList<>();
    private static final int MAX_LOGS = 1000;
    
    @Override
    public void handleClientRequest(User user, ISFSObject params) {
        if (user.getPrivilegeId() < 50) {
            sendError(user, "PERMISSION_DENIED", "Insufficient privileges");
            return;
        }
        
        String action = params.containsKey("action") ? params.getUtfString("action") : "view";
        int limit = params.containsKey("limit") ? params.getInt("limit") : 100;
        String level = params.containsKey("level") ? params.getUtfString("level") : "all";
        
        switch (action) {
            case "clear":
                clearLogs(user);
                break;
            case "view":
            default:
                sendLogs(user, limit, level);
                break;
        }
    }
    
    private void sendLogs(User user, int limit, String level) {
        SFSObject response = new SFSObject();
        SFSArray logs = new SFSArray();
        
        int count = 0;
        for (int i = systemLogs.size() - 1; i >= 0 && count < limit; i--) {
            String log = systemLogs.get(i);
            
            if (level.equals("all") || log.contains("[" + level.toUpperCase() + "]")) {
                SFSObject logEntry = new SFSObject();
                logEntry.putUtfString("message", log);
                logEntry.putLong("index", i);
                logEntry.putInt("totalLogs", systemLogs.size());
                
                logs.addSFSObject(logEntry);
                count++;
            }
        }
        
        response.putSFSArray("logs", logs);
        response.putInt("totalLogs", systemLogs.size());
        response.putInt("displayedLogs", count);
        response.putUtfString("status", "success");
        
        send("systemlog", response, user);
        ((MainExtension) getParentExtension()).markResponseSent("systemlog", user);
    }
    
    private void clearLogs(User user) {
        if (user.getPrivilegeId() < 100) {
            sendError(user, "PERMISSION_DENIED", "Only admins can clear logs");
            return;
        }
        
        systemLogs.clear();
        addLog("SYSTEM", "Logs cleared by " + user.getName());
        
        SFSObject response = new SFSObject();
        response.putUtfString("status", "success");
        response.putUtfString("message", "Logs cleared successfully");
        
        send("systemlog", response, user);
        ((MainExtension) getParentExtension()).markResponseSent("systemlog", user);
    }
    
    public static void addLog(String type, String message) {
        String timestamp = new java.util.Date().toString();
        String logEntry = "[" + timestamp + "] [" + type + "] " + message;
        
        systemLogs.add(logEntry);
        
        // Maintain max size
        if (systemLogs.size() > MAX_LOGS) {
            systemLogs.remove(0);
        }
    }
    
    private void sendError(User user, String errorCode, String message) {
        SFSObject error = new SFSObject();
        error.putUtfString("status", "error");
        error.putUtfString("errorCode", errorCode);
        error.putUtfString("message", message);
        send("systemlog", error, user);
    }
}