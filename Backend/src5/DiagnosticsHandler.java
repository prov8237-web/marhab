package src5;

import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.data.ISFSObject;
import com.smartfoxserver.v2.entities.data.SFSObject;
import com.smartfoxserver.v2.extensions.BaseClientRequestHandler;

public class DiagnosticsHandler extends BaseClientRequestHandler {
    
    @Override
    public void handleClientRequest(User user, ISFSObject params) {
        if (user.getPrivilegeId() < 50) {
            sendError(user, "PERMISSION_DENIED", "Insufficient privileges");
            return;
        }
        
        String mode = params.containsKey("mode") ? params.getUtfString("mode") : "basic";
        
        SFSObject response = new SFSObject();
        SFSObject diagnostics = new SFSObject();
        
        runBasicDiagnostics(diagnostics);
        
        response.putSFSObject("diagnostics", diagnostics);
        response.putUtfString("status", "success");
        response.putUtfString("mode", mode);
        response.putLong("timestamp", System.currentTimeMillis());
        
        send("diagnostics", response, user);
        ((MainExtension) getParentExtension()).markResponseSent("diagnostics", user);
        
        SystemLogHandler.addLog("DIAGNOSTICS", user.getName() + " ran diagnostics");
    }
    
    private void runBasicDiagnostics(SFSObject diag) {
        MainExtension ext = (MainExtension) getParentExtension();
        
        diag.putUtfString("serverName", "Marhab Server");
        diag.putUtfString("version", "2.0.0");
        diag.putLong("uptime", ext.getUptime());
        diag.putUtfString("uptimeFormatted", formatUptime(ext.getUptime()));
        
        // Memory
        Runtime runtime = Runtime.getRuntime();
        diag.putLong("totalMemoryMB", runtime.totalMemory() / (1024 * 1024));
        diag.putLong("freeMemoryMB", runtime.freeMemory() / (1024 * 1024));
        diag.putLong("usedMemoryMB", (runtime.totalMemory() - runtime.freeMemory()) / (1024 * 1024));
        diag.putLong("maxMemoryMB", runtime.maxMemory() / (1024 * 1024));
        
        // Note: إزالة getParentZone() calls
        diag.putInt("totalUsers", 0); // مؤقتاً
        diag.putInt("totalRooms", 0); // مؤقتاً
        
        // Commands
        diag.putInt("registeredHandlers", ((MainExtension) getParentExtension()).getCommandStats().size());
    }
    
    private String formatUptime(long millis) {
        long seconds = millis / 1000;
        long minutes = seconds / 60;
        long hours = minutes / 60;
        long days = hours / 24;
        
        return String.format("%d days, %d:%02d:%02d", 
            days, hours % 24, minutes % 60, seconds % 60);
    }
    
    private void sendError(User user, String errorCode, String message) {
        SFSObject error = new SFSObject();
        error.putUtfString("status", "error");
        error.putUtfString("errorCode", errorCode);
        error.putUtfString("message", message);
        send("diagnostics", error, user);
    }
}