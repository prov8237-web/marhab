package src5;

import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.data.ISFSObject;
import com.smartfoxserver.v2.entities.data.SFSObject;
import com.smartfoxserver.v2.extensions.BaseClientRequestHandler;
import java.util.HashMap;
import java.util.Map;

public class SecurityHandler extends BaseClientRequestHandler {
    
    private Map<String, Integer> requestCounts = new HashMap<>();
    private Map<String, Long> lastRequestTime = new HashMap<>();
    private Map<String, Integer> failedAttempts = new HashMap<>();
    
    @Override
    public void handleClientRequest(User user, ISFSObject params) {
        // نستخدم الأمر من اسم الـ handler المسجل
        String requestId = this.getClass().getSimpleName().replace("Handler", "").toLowerCase();
        
        // نفحص نوع العملية من params
        String operation = params.containsKey("operation") ? params.getUtfString("operation") : "validate";
        
        switch (operation) {
            case "validate":
                validateUser(user, params);
                break;
            case "session":
                checkSession(user, params);
                break;
            case "antibot":
                antiBotCheck(user, params);
                break;
            case "ratelimit":
                checkRateLimit(user, params);
                break;
            default:
                validateUser(user, params);
                break;
        }
    }
    
    private void validateUser(User user, ISFSObject params) {
        SFSObject response = new SFSObject();
        
        response.putBool("isValid", true);
        response.putInt("userId", user.getId());
        response.putUtfString("username", user.getName());
        response.putInt("privilege", user.getPrivilegeId());
        response.putLong("loginTime", user.getLoginTime());
        response.putBool("isConnected", user.isConnected());
        response.putLong("sessionDuration", System.currentTimeMillis() - user.getLoginTime());
        
        // Check for suspicious activity
        String ip = user.getSession().getAddress();
        int failedCount = failedAttempts.getOrDefault(ip, 0);
        response.putInt("failedAttempts", failedCount);
        response.putBool("isSuspicious", failedCount > 5);
        
        send("validateuser", response, user);
        ((MainExtension) getParentExtension()).markResponseSent("validateuser", user);
    }
    
    private void checkSession(User user, ISFSObject params) {
        long sessionDuration = System.currentTimeMillis() - user.getLoginTime();
        long maxSessionTime = 8 * 60 * 60 * 1000; // 8 hours
        
        SFSObject response = new SFSObject();
        response.putLong("sessionDuration", sessionDuration);
        response.putLong("loginTime", user.getLoginTime());
        response.putBool("isValid", sessionDuration < maxSessionTime);
        response.putLong("timeRemaining", maxSessionTime - sessionDuration);
        
        if (sessionDuration > maxSessionTime) {
            response.putUtfString("warning", "Session expired, please reconnect");
        }
        
        send("sessioncheck", response, user);
        ((MainExtension) getParentExtension()).markResponseSent("sessioncheck", user);
    }
    
    private void antiBotCheck(User user, ISFSObject params) {
        // Simple anti-bot check
        String ip = user.getSession().getAddress();
        String userAgent = params.containsKey("userAgent") ? params.getUtfString("userAgent") : "";
        
        SFSObject response = new SFSObject();
        
        // Check user agent
        boolean hasValidUserAgent = userAgent != null && userAgent.length() > 10;
        boolean isKnownBot = userAgent.contains("bot") || userAgent.contains("Bot") || 
                           userAgent.contains("crawler") || userAgent.contains("spider");
        
        boolean isBot = isKnownBot;
        
        response.putBool("isBot", isBot);
        response.putBool("validUserAgent", hasValidUserAgent);
        response.putBool("knownBot", isKnownBot);
        response.putUtfString("recommendation", isBot ? "block" : "allow");
        
        send("antibotcheck", response, user);
        ((MainExtension) getParentExtension()).markResponseSent("antibotcheck", user);
        
        if (isBot) {
            SystemLogHandler.addLog("SECURITY", "Possible bot detected: " + user.getName() + " IP: " + ip);
            failedAttempts.put(ip, failedAttempts.getOrDefault(ip, 0) + 1);
        }
    }
    
    private void checkRateLimit(User user, ISFSObject params) {
        String ip = user.getSession().getAddress();
        
        SFSObject response = new SFSObject();
        response.putInt("requestCount", 1);
        response.putInt("limit", 100);
        response.putBool("isLimited", false);
        response.putLong("resetTime", System.currentTimeMillis() + 60000);
        response.putInt("remaining", 99);
        
        send("ratelimit", response, user);
        ((MainExtension) getParentExtension()).markResponseSent("ratelimit", user);
    }
}