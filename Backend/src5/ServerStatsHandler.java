package src5;

import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.data.ISFSObject;
import com.smartfoxserver.v2.entities.data.SFSObject;
import com.smartfoxserver.v2.extensions.BaseClientRequestHandler;

public class ServerStatsHandler extends BaseClientRequestHandler {
    
    @Override
    public void handleClientRequest(User user, ISFSObject params) {
        if (user.getPrivilegeId() < 50) {
            sendError(user, "PERMISSION_DENIED", "Insufficient privileges");
            return;
        }
        
        MainExtension ext = (MainExtension) getParentExtension();
        
        SFSObject response = new SFSObject();
        SFSObject stats = new SFSObject();
        
        // Server Information
        stats.putUtfString("serverName", "Marhab Server");
        stats.putUtfString("version", "2.0.0");
        stats.putLong("startTime", ext.getCreationTime());
        stats.putLong("uptime", ext.getUptime());
        stats.putUtfString("uptimeFormatted", formatUptime(ext.getUptime()));
        
        // User Statistics (مؤقتاً بدون getParentZone())
        stats.putInt("totalUsers", 0);
        stats.putInt("roomsCount", 0);
        
        // Command Statistics
        stats.putInt("totalCommands", ext.getCommandStats().size());
        int totalRequests = ext.getCommandStats().values().stream().mapToInt(Integer::intValue).sum();
        stats.putInt("totalRequests", totalRequests);
        
        // Memory Statistics
        Runtime runtime = Runtime.getRuntime();
        stats.putLong("totalMemory", runtime.totalMemory());
        stats.putLong("freeMemory", runtime.freeMemory());
        stats.putLong("usedMemory", runtime.totalMemory() - runtime.freeMemory());
        stats.putLong("maxMemory", runtime.maxMemory());
        stats.putDouble("memoryUsagePercent", 
            ((double)(runtime.totalMemory() - runtime.freeMemory()) / runtime.totalMemory()) * 100);
        
        // CPU Statistics
        stats.putInt("availableProcessors", runtime.availableProcessors());
        
        // Network Statistics (مؤقتاً)
        stats.putInt("activeConnections", 0);
        
        // Performance Metrics
        stats.putLong("timestamp", System.currentTimeMillis());
        
        response.putSFSObject("stats", stats);
        response.putUtfString("status", "success");
        
        send("serverstats", response, user);
        ext.markResponseSent("serverstats", user);
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
        send("serverstats", error, user);
    }
}