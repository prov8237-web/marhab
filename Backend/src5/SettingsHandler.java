package src5;

import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.data.ISFSObject;
import com.smartfoxserver.v2.entities.data.SFSObject;
import com.smartfoxserver.v2.extensions.BaseClientRequestHandler;
import java.util.Map;

public class SettingsHandler extends BaseClientRequestHandler {
    
    @Override
    public void handleClientRequest(User user, ISFSObject params) {
        // نستخدم الأمر من params أو الافتراضي
        String action = params.containsKey("action") ? params.getUtfString("action") : "get";
        
        switch (action) {
            case "get":
                handleGetSettings(user);
                break;
            case "update":
                handleUpdateSettings(user, params);
                break;
            case "reset":
                handleResetSettings(user);
                break;
            case "export":
                handleExportSettings(user);
                break;
            case "import":
                handleImportSettings(user, params);
                break;
            default:
                handleGetSettings(user);
                break;
        }
    }
    
    private void handleGetSettings(User user) {
        MainExtension ext = (MainExtension) getParentExtension();
        Map<String, Object> config = ext.getServerConfig();
        
        SFSObject response = new SFSObject();
        SFSObject settings = new SFSObject();
        
        for (Map.Entry<String, Object> entry : config.entrySet()) {
            Object value = entry.getValue();
            if (value instanceof String) {
                settings.putUtfString(entry.getKey(), (String) value);
            } else if (value instanceof Integer) {
                settings.putInt(entry.getKey(), (Integer) value);
            } else if (value instanceof Boolean) {
                settings.putBool(entry.getKey(), (Boolean) value);
            } else if (value instanceof Long) {
                settings.putLong(entry.getKey(), (Long) value);
            }
        }
        
        response.putSFSObject("settings", settings);
        response.putUtfString("status", "success");
        send("getsettings", response, user);
        ext.markResponseSent("getsettings", user);
    }
    
    private void handleUpdateSettings(User user, ISFSObject params) {
        if (user.getPrivilegeId() < 100) {
            sendError("updatesettings", user, "PERMISSION_DENIED", "Admin privileges required");
            return;
        }
        
        MainExtension ext = (MainExtension) getParentExtension();
        
        // إزالة action من params
        if (params.containsKey("action")) {
            params.removeElement("action");
        }
        
        for (String key : params.getKeys()) {
            Object value = params.get(key);
            ext.updateServerConfig(key, value);
        }
        
        SFSObject response = new SFSObject();
        response.putUtfString("status", "success");
        response.putUtfString("message", "Settings updated successfully");
        send("updatesettings", response, user);
        ext.markResponseSent("updatesettings", user);
    }
    
    private void handleResetSettings(User user) {
        if (user.getPrivilegeId() < 100) {
            sendError("resetsettings", user, "PERMISSION_DENIED", "Admin privileges required");
            return;
        }
        
        MainExtension ext = (MainExtension) getParentExtension();
        
        // Reset to default settings
        Map<String, Object> defaultConfig = Map.of(
            "serverName", "Marhab Official Server",
            "version", "2.0.0",
            "maxPlayers", 1000,
            "chatEnabled", true,
            "tradingEnabled", true,
            "diamondTransferEnabled", true,
            "logLevel", "INFO",
            "maintenanceMode", false,
            "debugMode", false
        );
        
        for (Map.Entry<String, Object> entry : defaultConfig.entrySet()) {
            ext.updateServerConfig(entry.getKey(), entry.getValue());
        }
        
        SFSObject response = new SFSObject();
        response.putUtfString("status", "success");
        response.putUtfString("message", "Settings reset to defaults");
        send("resetsettings", response, user);
        ext.markResponseSent("resetsettings", user);
    }
    
    private void handleExportSettings(User user) {
        if (user.getPrivilegeId() < 100) {
            sendError("exportsettings", user, "PERMISSION_DENIED", "Admin privileges required");
            return;
        }
        
        try {
            MainExtension ext = (MainExtension) getParentExtension();
            Map<String, Object> config = ext.getServerConfig();
            
            StringBuilder sb = new StringBuilder();
            sb.append("# Server Configuration Export\n");
            sb.append("# Generated: ").append(new java.util.Date()).append("\n");
            sb.append("# User: ").append(user.getName()).append("\n\n");
            
            for (Map.Entry<String, Object> entry : config.entrySet()) {
                sb.append(entry.getKey()).append("=").append(entry.getValue()).append("\n");
            }
            
            SFSObject response = new SFSObject();
            response.putUtfString("status", "success");
            response.putUtfString("configData", sb.toString());
            response.putLong("exportTime", System.currentTimeMillis());
            
            send("exportsettings", response, user);
            ext.markResponseSent("exportsettings", user);
            
        } catch (Exception e) {
            sendError("exportsettings", user, "EXPORT_FAILED", e.getMessage());
        }
    }
    
    private void handleImportSettings(User user, ISFSObject params) {
        if (user.getPrivilegeId() < 100) {
            sendError("importsettings", user, "PERMISSION_DENIED", "Admin privileges required");
            return;
        }
        
        if (!params.containsKey("configData")) {
            sendError("importsettings", user, "INVALID_DATA", "configData is required");
            return;
        }
        
        try {
            String configData = params.getUtfString("configData");
            MainExtension ext = (MainExtension) getParentExtension();
            
            String[] lines = configData.split("\n");
            int imported = 0;
            
            for (String line : lines) {
                line = line.trim();
                if (line.isEmpty() || line.startsWith("#")) {
                    continue;
                }
                
                String[] parts = line.split("=", 2);
                if (parts.length == 2) {
                    String key = parts[0].trim();
                    String value = parts[1].trim();
                    
                    Object typedValue;
                    if (value.equalsIgnoreCase("true") || value.equalsIgnoreCase("false")) {
                        typedValue = Boolean.parseBoolean(value);
                    } else if (value.matches("\\d+")) {
                        typedValue = Integer.parseInt(value);
                    } else {
                        typedValue = value;
                    }
                    
                    ext.updateServerConfig(key, typedValue);
                    imported++;
                }
            }
            
            SFSObject response = new SFSObject();
            response.putUtfString("status", "success");
            response.putUtfString("message", "Imported " + imported + " settings");
            response.putInt("importedCount", imported);
            
            send("importsettings", response, user);
            ext.markResponseSent("importsettings", user);
            
        } catch (Exception e) {
            sendError("importsettings", user, "IMPORT_FAILED", e.getMessage());
        }
    }
    
    private void sendError(String command, User user, String errorCode, String message) {
        SFSObject error = new SFSObject();
        error.putUtfString("status", "error");
        error.putUtfString("errorCode", errorCode);
        error.putUtfString("message", message);
        send(command, error, user);
    }
}