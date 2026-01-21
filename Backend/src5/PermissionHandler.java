package src5;

import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.data.ISFSObject;
import com.smartfoxserver.v2.entities.data.SFSObject;
import com.smartfoxserver.v2.extensions.BaseClientRequestHandler;

public class PermissionHandler extends BaseClientRequestHandler {
    
    @Override
    public void handleClientRequest(User sender, ISFSObject params) {
        // فقط السوبر أدمن يمكنه تعديل الصلاحيات
        if (sender.getPrivilegeId() < 1000) {
            sendError(sender, "PERMISSION_DENIED", "SuperAdmin privileges required");
            return;
        }
        
        String action = params.containsKey("action") ? params.getUtfString("action") : "view";
        String targetUsername = params.getUtfString("targetUser");
        int newPrivilege = params.getInt("privilege");
        
        switch (action) {
            case "set":
                setUserPrivilege(sender, targetUsername, newPrivilege);
                break;
            case "view":
                viewUserPrivilege(sender, targetUsername);
                break;
            case "list":
                listPrivilegedUsers(sender);
                break;
        }
    }
    
    private void setUserPrivilege(User admin, String targetUsername, int privilegeLevel) {
        // هنا كود ربط مع قاعدة البيانات لتحديث الصلاحية
        // مؤقتاً: نرسل رداً فقط
        
        SFSObject response = new SFSObject();
        response.putUtfString("status", "success");
        response.putUtfString("message", "Privilege updated for user: " + targetUsername);
        response.putInt("newPrivilege", privilegeLevel);
        response.putUtfString("privilegeName", getPrivilegeName(privilegeLevel));
        
        send("setpermission", response, admin);
        ((MainExtension) getParentExtension()).markResponseSent("setpermission", admin);
        
        SystemLogHandler.addLog("PERMISSION", admin.getName() + " set privilege for " + 
                              targetUsername + " to " + getPrivilegeName(privilegeLevel));
    }
    
    private void viewUserPrivilege(User admin, String targetUsername) {
        SFSObject response = new SFSObject();
        response.putUtfString("status", "success");
        response.putUtfString("targetUser", targetUsername);
        response.putInt("privilege", 0); // Default: Guest
        response.putUtfString("privilegeName", "Guest");
        response.putUtfString("note", "Connect to database to get real privilege");
        
        send("viewpermission", response, admin);
        ((MainExtension) getParentExtension()).markResponseSent("viewpermission", admin);
    }
    
    private void listPrivilegedUsers(User admin) {
        SFSObject response = new SFSObject();
        response.putUtfString("status", "success");
        response.putUtfString("message", "Privileged users list");
        response.putUtfString("note", "Database integration required for full list");
        
        send("listpermissions", response, admin);
        ((MainExtension) getParentExtension()).markResponseSent("listpermissions", admin);
    }
    
    private String getPrivilegeName(int level) {
        switch (level) {
            case 0: return "Guest";
            case 1: return "Normal User";
            case 50: return "Moderator";
            case 100: return "Admin";
            case 1000: return "SuperAdmin";
            default: return "Custom (" + level + ")";
        }
    }
    
    private void sendError(User user, String errorCode, String message) {
        SFSObject error = new SFSObject();
        error.putUtfString("status", "error");
        error.putUtfString("errorCode", errorCode);
        error.putUtfString("message", message);
        send("permission", error, user);
    }
}