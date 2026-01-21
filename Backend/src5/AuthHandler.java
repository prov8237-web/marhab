package src5;

import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.data.ISFSObject;
import com.smartfoxserver.v2.entities.data.SFSObject;
import com.smartfoxserver.v2.extensions.BaseClientRequestHandler;
import java.sql.*;

public class AuthHandler extends BaseClientRequestHandler {
    
    private Connection connection;
    
    @Override
    public void handleClientRequest(User user, ISFSObject params) {
        String action = params.containsKey("action") ? params.getUtfString("action") : "login";
        
        switch (action) {
            case "login":
                handleLogin(user, params);
                break;
            case "register":
                handleRegister(user, params);
                break;
            case "changepassword":
                handleChangePassword(user, params);
                break;
        }
    }
    
    private void handleLogin(User user, ISFSObject params) {
        String username = params.getUtfString("username");
        String password = params.getUtfString("password");
        
        try {
            // الاتصال بقاعدة البيانات
            if (connection == null) {
                connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/marhab", "root", "");
            }
            
            // التحقق من المستخدم
            String sql = "SELECT id, username, privilege_level FROM users WHERE username = ? AND password = ?";
            PreparedStatement stmt = connection.prepareStatement(sql);
            stmt.setString(1, username);
            stmt.setString(2, hashPassword(password));
            
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                int privilegeLevel = rs.getInt("privilege_level");
                
                // هنا يمكنك تعيين الصلاحية للمستخدم
                // user.setPrivilegeId(privilegeLevel); // إذا كان متاحاً
                
                SFSObject response = new SFSObject();
                response.putUtfString("status", "success");
                response.putUtfString("message", "Login successful");
                response.putInt("privilege", privilegeLevel);
                response.putUtfString("privilegeName", getPrivilegeName(privilegeLevel));
                
                send("login", response, user);
            } else {
                sendError(user, "LOGIN_FAILED", "Invalid username or password");
            }
            
        } catch (Exception e) {
            sendError(user, "DATABASE_ERROR", e.getMessage());
        }
    }
    
    private void handleRegister(User user, ISFSObject params) {
        String username = params.getUtfString("username");
        String password = params.getUtfString("password");
        String email = params.getUtfString("email");
        
        try {
            if (connection == null) {
                connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/marhab", "root", "");
            }
            
            // التحقق إذا كان المستخدم موجود
            String checkSql = "SELECT id FROM users WHERE username = ?";
            PreparedStatement checkStmt = connection.prepareStatement(checkSql);
            checkStmt.setString(1, username);
            
            if (checkStmt.executeQuery().next()) {
                sendError(user, "USER_EXISTS", "Username already exists");
                return;
            }
            
            // إنشاء مستخدم جديد
            String insertSql = "INSERT INTO users (username, password, email, privilege_level, created_at) " +
                              "VALUES (?, ?, ?, 1, NOW())";
            PreparedStatement insertStmt = connection.prepareStatement(insertSql);
            insertStmt.setString(1, username);
            insertStmt.setString(2, hashPassword(password));
            insertStmt.setString(3, email);
            
            int rows = insertStmt.executeUpdate();
            
            if (rows > 0) {
                SFSObject response = new SFSObject();
                response.putUtfString("status", "success");
                response.putUtfString("message", "Registration successful");
                response.putInt("privilege", 1); // Normal user
                
                send("register", response, user);
            }
            
        } catch (Exception e) {
            sendError(user, "REGISTRATION_FAILED", e.getMessage());
        }
    }
    
    private void handleChangePassword(User user, ISFSObject params) {
        String oldPassword = params.getUtfString("oldPassword");
        String newPassword = params.getUtfString("newPassword");
        
        // منطق تغيير الباسورد
    }
    
    private String hashPassword(String password) {
        // دالة لتشفير الباسورد
        return password; // مؤقتاً
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
        send("auth", error, user);
    }
}