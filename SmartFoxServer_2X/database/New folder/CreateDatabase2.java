import java.sql.*;

public class CreateDatabase {
    public static void main(String[] args) {
        // المسار الكامل لقاعدة البيانات
        String url = "jdbc:sqlite:C:/Users/mmo5h/SmartFoxServer_2X/SFS2X/database/game_users.db";
        
        System.out.println("=== إنشاء قاعدة بيانات اللعبة ===");
        System.out.println("المسار: " + url);
        
        try {
            // إنشاء اتصال مع قاعدة البيانات (سيتم إنشاء الملف إذا لم يكن موجوداً)
            Connection conn = DriverManager.getConnection(url);
            
            if (conn != null) {
                System.out.println("✅ تم إنشاء قاعدة البيانات بنجاح!");
                
                // إنشاء الجداول
                createTables(conn);
                
                // إضافة مستخدم تجريبي
                addTestUser(conn);
                
                conn.close();
                System.out.println("✅ تم إنشاء جميع الجداول!");
                System.out.println("\nمستخدم تجريبي:");
                System.out.println("اسم المستخدم: test");
                System.out.println("كلمة المرور: test123");
            }
            
        } catch (SQLException e) {
            System.out.println("❌ خطأ: " + e.getMessage());
        }
    }
    
    private static void createTables(Connection conn) throws SQLException {
        Statement stmt = conn.createStatement();
        
        // 1. جدول المستخدمين
        String usersTable = "CREATE TABLE IF NOT EXISTS users (" +
            "id INTEGER PRIMARY KEY AUTOINCREMENT, " +
            "username TEXT UNIQUE NOT NULL, " +
            "password TEXT NOT NULL, " +
            "email TEXT, " +
            "created_date DATETIME DEFAULT CURRENT_TIMESTAMP, " +
            "last_login DATETIME, " +
            "is_online BOOLEAN DEFAULT 0" +
            ");";
        
        // 2. جدول إحصائيات اللاعب
        String playerStats = "CREATE TABLE IF NOT EXISTS player_stats (" +
            "user_id INTEGER PRIMARY KEY, " +
            "level INTEGER DEFAULT 1, " +
            "experience INTEGER DEFAULT 0, " +
            "coins INTEGER DEFAULT 1000, " +
            "score INTEGER DEFAULT 0, " +
            "FOREIGN KEY(user_id) REFERENCES users(id)" +
            ");";
        
        stmt.execute(usersTable);
        stmt.execute(playerStats);
        
        System.out.println("✅ تم إنشاء جدول المستخدمين");
        System.out.println("✅ تم إنشاء جدول إحصائيات اللاعبين");
    }
    
    private static void addTestUser(Connection conn) throws SQLException {
        // التحقق إذا كان المستخدم موجود مسبقاً
        String checkSql = "SELECT COUNT(*) FROM users WHERE username = 'test'";
        Statement checkStmt = conn.createStatement();
        ResultSet rs = checkStmt.executeQuery(checkSql);
        
        if (rs.next() && rs.getInt(1) == 0) {
            // إضافة مستخدم تجريبي
            String insertSql = "INSERT INTO users (username, password, email) VALUES ('test', 'test123', 'test@game.com')";
            Statement insertStmt = conn.createStatement();
            insertStmt.executeUpdate(insertSql);
            
            // الحصول على ID المستخدم الجديد
            String getIdSql = "SELECT last_insert_rowid()";
            Statement idStmt = conn.createStatement();
            ResultSet idRs = idStmt.executeQuery(getIdSql);
            
            if (idRs.next()) {
                int userId = idRs.getInt(1);
                
                // إضافة إحصائيات للاعب
                String statsSql = "INSERT INTO player_stats (user_id) VALUES (" + userId + ")";
                Statement statsStmt = conn.createStatement();
                statsStmt.executeUpdate(statsSql);
            }
        }
    }
}