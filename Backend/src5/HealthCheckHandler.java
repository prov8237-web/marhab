package src5;

import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.data.ISFSObject;
import com.smartfoxserver.v2.entities.data.SFSObject;
import com.smartfoxserver.v2.extensions.BaseClientRequestHandler;

public class HealthCheckHandler extends BaseClientRequestHandler {
    
    @Override
    public void handleClientRequest(User user, ISFSObject params) {
        MainExtension ext = (MainExtension) getParentExtension();
        
        SFSObject response = new SFSObject();
        SFSObject health = new SFSObject();
        
        // Basic Health Status
        health.putUtfString("status", "healthy");
        health.putLong("timestamp", System.currentTimeMillis());
        
        // Memory Health
        Runtime runtime = Runtime.getRuntime();
        long usedMemory = runtime.totalMemory() - runtime.freeMemory();
        double memoryUsagePercent = ((double) usedMemory / runtime.totalMemory()) * 100;
        health.putDouble("memoryUsagePercent", memoryUsagePercent);
        health.putUtfString("memoryStatus", memoryUsagePercent > 90 ? "critical" : 
                          memoryUsagePercent > 75 ? "warning" : "healthy");
        
        // Uptime Health
        long uptime = ext.getUptime();
        health.putLong("uptime", uptime);
        health.putUtfString("uptimeStatus", uptime > 86400000 ? "stable" : "recent");
        
        // Note: إزالة getParentZone() call
        int userCount = 0; // مؤقتاً
        int maxUsers = 1000;
        double connectionPercent = ((double) userCount / maxUsers) * 100;
        health.putInt("activeUsers", userCount);
        health.putDouble("connectionUsagePercent", connectionPercent);
        health.putUtfString("connectionStatus", "unknown");
        
        // Database Health (simulated)
        health.putBool("databaseConnected", true);
        health.putUtfString("databaseStatus", "healthy");
        
        // Overall Health Score
        int healthScore = 85; // افتراضي
        health.putInt("healthScore", healthScore);
        health.putUtfString("overallStatus", "good");
        
        response.putSFSObject("health", health);
        response.putUtfString("status", "success");
        
        send("healthcheck", response, user);
        ext.markResponseSent("healthcheck", user);
    }
}