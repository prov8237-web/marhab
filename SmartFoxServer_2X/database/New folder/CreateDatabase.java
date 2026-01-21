import java.sql.*;

public class CreateDatabase {
    public static void main(String[] args) {
        // المسار الكامل لقاعدة البيانات - تأكد من المسار
        String url = "jdbc:sqlite:C:/Users/mmo5h/SmartFoxServer_2X/SFS2X/database/game_users.db";
        
        System.out.println("=== إنشاء قاعدة بيانات اللعبة ===");
        System.out.println("المسار: " + url);
        
        try {
            // إنشاء اتصال مع قاعدة البيانات (سيتم إنشاء الملف إذا لم يكن موجوداً)
            Connection conn = DriverManager.getConnection(url);
            
            if (conn != null) {
                System.out.println("✅ تم إنشاء قاعدة البيانات بنجاح!");
                
                // إنشاء جميع الجداول
                createTables(conn);
                
                // إضافة مستخدم تجريبي
                addTestUser(conn);
                
                // إضافة بيانات تجريبية أخرى
                addSampleData(conn);
                
                conn.close();
                System.out.println("\n✅ تم إنشاء جميع الجداول والبيانات!");
                System.out.println("\n📋 بيانات الدخول:");
                System.out.println("اسم المستخدم: test");
                System.out.println("كلمة المرور: test123");
                System.out.println("البريد الإلكتروني: test@game.com");
            }
            
        } catch (SQLException e) {
            System.out.println("❌ خطأ: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    private static void createTables(Connection conn) throws SQLException {
        Statement stmt = conn.createStatement();
        
        // ==================== 1. جدول المستخدمين ====================
        String usersTable = "CREATE TABLE IF NOT EXISTS users (" +
            "id INTEGER PRIMARY KEY AUTOINCREMENT, " +
            "username TEXT UNIQUE NOT NULL, " +
            "password TEXT NOT NULL, " +
            "email TEXT, " +
            "created_date DATETIME DEFAULT CURRENT_TIMESTAMP, " +
            "last_login DATETIME, " +
            "is_online BOOLEAN DEFAULT 0, " +
            "privilege INTEGER DEFAULT 1, " +
            "gender TEXT DEFAULT 'm', " +
            "avatar_name TEXT" +
            ");";
        
        // ==================== 2. جدول إحصائيات اللاعب ====================
        String playerStats = "CREATE TABLE IF NOT EXISTS player_stats (" +
            "user_id INTEGER PRIMARY KEY, " +
            "level INTEGER DEFAULT 1, " +
            "experience INTEGER DEFAULT 0, " +
            "coins INTEGER DEFAULT 1000, " +
            "diamonds INTEGER DEFAULT 50, " +
            "score INTEGER DEFAULT 0, " +
            "total_play_time INTEGER DEFAULT 0, " +
            "achievements_completed INTEGER DEFAULT 0, " +
            "last_updated DATETIME DEFAULT CURRENT_TIMESTAMP, " +
            "FOREIGN KEY(user_id) REFERENCES users(id) ON DELETE CASCADE" +
            ");";
        
        // ==================== 3. جدول الملابس والمقتنيات ====================
        String inventoryTable = "CREATE TABLE IF NOT EXISTS inventory (" +
            "id INTEGER PRIMARY KEY AUTOINCREMENT, " +
            "user_id INTEGER NOT NULL, " +
            "item_type TEXT NOT NULL, " +  // CLOTH, HAND_ITEM, ETC
            "item_id INTEGER NOT NULL, " +
            "item_name TEXT, " +
            "quantity INTEGER DEFAULT 1, " +
            "color TEXT, " +
            "equipped BOOLEAN DEFAULT 0, " +
            "purchase_date DATETIME DEFAULT CURRENT_TIMESTAMP, " +
            "expire_date DATETIME, " +
            "FOREIGN KEY(user_id) REFERENCES users(id) ON DELETE CASCADE" +
            ");";
        
        // ==================== 4. جدول الأصدقاء ====================
        String friendsTable = "CREATE TABLE IF NOT EXISTS friends (" +
            "id INTEGER PRIMARY KEY AUTOINCREMENT, " +
            "user_id INTEGER NOT NULL, " +
            "friend_id INTEGER NOT NULL, " +
            "status TEXT DEFAULT 'pending', " +  // pending, accepted, blocked
            "friend_since DATETIME DEFAULT CURRENT_TIMESTAMP, " +
            "FOREIGN KEY(user_id) REFERENCES users(id) ON DELETE CASCADE, " +
            "FOREIGN KEY(friend_id) REFERENCES users(id) ON DELETE CASCADE, " +
            "UNIQUE(user_id, friend_id)" +
            ");";
        
        // ==================== 5. جدول المحادثات ====================
        String chatTable = "CREATE TABLE IF NOT EXISTS chat_logs (" +
            "id INTEGER PRIMARY KEY AUTOINCREMENT, " +
            "user_id INTEGER NOT NULL, " +
            "room_name TEXT, " +
            "message TEXT NOT NULL, " +
            "message_type TEXT DEFAULT 'public', " +  // public, private, system
            "sent_date DATETIME DEFAULT CURRENT_TIMESTAMP, " +
            "FOREIGN KEY(user_id) REFERENCES users(id) ON DELETE CASCADE" +
            ");";
        
        // ==================== 6. جدول الإنجازات ====================
        String achievementsTable = "CREATE TABLE IF NOT EXISTS achievements (" +
            "id INTEGER PRIMARY KEY AUTOINCREMENT, " +
            "user_id INTEGER NOT NULL, " +
            "achievement_id INTEGER NOT NULL, " +
            "achievement_name TEXT NOT NULL, " +
            "progress INTEGER DEFAULT 0, " +
            "completed BOOLEAN DEFAULT 0, " +
            "completed_date DATETIME, " +
            "reward_received BOOLEAN DEFAULT 0, " +
            "FOREIGN KEY(user_id) REFERENCES users(id) ON DELETE CASCADE" +
            ");";
        
        // ==================== 7. جدول الجلسات ====================
        String sessionsTable = "CREATE TABLE IF NOT EXISTS user_sessions (" +
            "session_id TEXT PRIMARY KEY, " +
            "user_id INTEGER NOT NULL, " +
            "ip_address TEXT, " +
            "login_time DATETIME DEFAULT CURRENT_TIMESTAMP, " +
            "last_activity DATETIME DEFAULT CURRENT_TIMESTAMP, " +
            "expire_time DATETIME, " +
            "FOREIGN KEY(user_id) REFERENCES users(id) ON DELETE CASCADE" +
            ");";
        
        // ==================== 8. جدول السجل ====================
        String logsTable = "CREATE TABLE IF NOT EXISTS system_logs (" +
            "id INTEGER PRIMARY KEY AUTOINCREMENT, " +
            "log_type TEXT NOT NULL, " +  // LOGIN, LOGOUT, ERROR, ACTION
            "user_id INTEGER, " +
            "description TEXT NOT NULL, " +
            "ip_address TEXT, " +
            "log_date DATETIME DEFAULT CURRENT_TIMESTAMP" +
            ");";
        
        // تنفيذ إنشاء الجداول
        stmt.execute(usersTable);
        stmt.execute(playerStats);
        stmt.execute(inventoryTable);
        stmt.execute(friendsTable);
        stmt.execute(chatTable);
        stmt.execute(achievementsTable);
        stmt.execute(sessionsTable);
        stmt.execute(logsTable);
        
        System.out.println("\n✅ تم إنشاء الجداول:");
        System.out.println("1. users - جدول المستخدمين");
        System.out.println("2. player_stats - إحصائيات اللاعبين");
        System.out.println("3. inventory - المخزون");
        System.out.println("4. friends - الأصدقاء");
        System.out.println("5. chat_logs - سجل المحادثات");
        System.out.println("6. achievements - الإنجازات");
        System.out.println("7. user_sessions - الجلسات");
        System.out.println("8. system_logs - سجل النظام");
        
        // إنشاء الفهارس لتحسين الأداء
        createIndexes(conn);
        
        stmt.close();
    }
    
    private static void createIndexes(Connection conn) throws SQLException {
        Statement stmt = conn.createStatement();
        
        // فهارس جدول المستخدمين
        stmt.execute("CREATE INDEX IF NOT EXISTS idx_users_username ON users(username);");
        stmt.execute("CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);");
        
        // فهارس جدول إحصائيات اللاعب
        stmt.execute("CREATE INDEX IF NOT EXISTS idx_player_stats_user ON player_stats(user_id);");
        
        // فهارس جدول المخزون
        stmt.execute("CREATE INDEX IF NOT EXISTS idx_inventory_user ON inventory(user_id);");
        stmt.execute("CREATE INDEX IF NOT EXISTS idx_inventory_type ON inventory(item_type);");
        
        // فهارس جدول الأصدقاء
        stmt.execute("CREATE INDEX IF NOT EXISTS idx_friends_user ON friends(user_id);");
        stmt.execute("CREATE INDEX IF NOT EXISTS idx_friends_friend ON friends(friend_id);");
        
        // فهارس جدول سجل المحادثات
        stmt.execute("CREATE INDEX IF NOT EXISTS idx_chat_user ON chat_logs(user_id);");
        stmt.execute("CREATE INDEX IF NOT EXISTS idx_chat_date ON chat_logs(sent_date);");
        
        // فهارس جدول الجلسات
        stmt.execute("CREATE INDEX IF NOT EXISTS idx_sessions_user ON user_sessions(user_id);");
        stmt.execute("CREATE INDEX IF NOT EXISTS idx_sessions_expire ON user_sessions(expire_time);");
        
        System.out.println("\n✅ تم إنشاء الفهارس لتحسين الأداء");
        
        stmt.close();
    }
    
    private static void addTestUser(Connection conn) throws SQLException {
        // التحقق إذا كان المستخدم موجود مسبقاً
        String checkSql = "SELECT COUNT(*) FROM users WHERE username = 'test'";
        Statement checkStmt = conn.createStatement();
        ResultSet rs = checkStmt.executeQuery(checkSql);
        
        if (rs.next() && rs.getInt(1) == 0) {
            // إضافة مستخدم تجريبي
            String insertSql = "INSERT INTO users (username, password, email, privilege, avatar_name) " +
                              "VALUES ('test', 'test123', 'test@game.com', 1, 'TestPlayer')";
            Statement insertStmt = conn.createStatement();
            insertStmt.executeUpdate(insertSql);
            
            // الحصول على ID المستخدم الجديد
            String getIdSql = "SELECT last_insert_rowid()";
            Statement idStmt = conn.createStatement();
            ResultSet idRs = idStmt.executeQuery(getIdSql);
            
            if (idRs.next()) {
                int userId = idRs.getInt(1);
                
                // إضافة إحصائيات للاعب
                String statsSql = "INSERT INTO player_stats (user_id, coins, diamonds) " +
                                 "VALUES (" + userId + ", 10000, 100)";
                Statement statsStmt = conn.createStatement();
                statsStmt.executeUpdate(statsSql);
                
                // إضافة ملابس افتراضية للمخزون
                addDefaultItems(conn, userId);
                
                // إضافة إنجازات افتراضية
                addDefaultAchievements(conn, userId);
                
                System.out.println("\n✅ تم إضافة المستخدم التجريبي (ID: " + userId + ")");
            }
            
            idStmt.close();
            insertStmt.close();
        } else {
            System.out.println("\n⚠️ المستخدم التجريبي موجود بالفعل");
        }
        
        checkStmt.close();
        rs.close();
    }
    
    private static void addDefaultItems(Connection conn, int userId) throws SQLException {
        PreparedStatement pstmt = conn.prepareStatement(
            "INSERT INTO inventory (user_id, item_type, item_id, item_name, color, equipped) " +
            "VALUES (?, ?, ?, ?, ?, ?)");
        
        // ملابس افتراضية
        String[][] defaultItems = {
            {"CLOTH", "1001", "T-Shirt Basic", "blue", "1"},
            {"CLOTH", "1002", "Jeans Simple", "blue", "1"},
            {"CLOTH", "1003", "Sneakers Basic", "white", "1"},
            {"HAND_ITEM", "2001", "Magic Wand", "gold", "0"},
            {"ACCESSORY", "3001", "Cool Glasses", "black", "0"}
        };
        
        for (String[] item : defaultItems) {
            pstmt.setInt(1, userId);
            pstmt.setString(2, item[0]);
            pstmt.setInt(3, Integer.parseInt(item[1]));
            pstmt.setString(4, item[2]);
            pstmt.setString(5, item[3]);
            pstmt.setBoolean(6, Boolean.parseBoolean(item[4]));
            pstmt.addBatch();
        }
        
        pstmt.executeBatch();
        pstmt.close();
        
        System.out.println("✅ تم إضافة 5 عناصر افتراضية للمخزون");
    }
    
    private static void addDefaultAchievements(Connection conn, int userId) throws SQLException {
        PreparedStatement pstmt = conn.prepareStatement(
            "INSERT INTO achievements (user_id, achievement_id, achievement_name) " +
            "VALUES (?, ?, ?)");
        
        // إنجازات افتراضية
        Object[][] achievements = {
            {userId, 1, "New Player"},
            {userId, 2, "First Login"},
            {userId, 3, "Welcome to Marhab"}
        };
        
        for (Object[] achievement : achievements) {
            pstmt.setInt(1, (int)achievement[0]);
            pstmt.setInt(2, (int)achievement[1]);
            pstmt.setString(3, (String)achievement[2]);
            pstmt.addBatch();
        }
        
        pstmt.executeBatch();
        pstmt.close();
        
        System.out.println("✅ تم إضافة 3 إنجازات افتراضية");
    }
    
    private static void addSampleData(Connection conn) throws SQLException {
        // إضافة مستخدمين عشوائيين للاختبار
        String[][] sampleUsers = {
            {"player1", "pass123", "player1@game.com", "Player One"},
            {"gamer2", "gamer456", "gamer2@game.com", "Pro Gamer"},
            {"guest1", "guest789", "guest1@game.com", "Guest Player"},
            {"admin", "admin123", "admin@game.com", "Game Admin"}
        };
        
        PreparedStatement userStmt = conn.prepareStatement(
            "INSERT OR IGNORE INTO users (username, password, email, avatar_name, privilege) " +
            "VALUES (?, ?, ?, ?, ?)");
        
        PreparedStatement statsStmt = conn.prepareStatement(
            "INSERT OR IGNORE INTO player_stats (user_id, coins, diamonds) VALUES (?, ?, ?)");
        
        int addedUsers = 0;
        for (String[] user : sampleUsers) {
            userStmt.setString(1, user[0]);
            userStmt.setString(2, user[1]);
            userStmt.setString(3, user[2]);
            userStmt.setString(4, user[3]);
            userStmt.setInt(5, user[0].equals("admin") ? 100 : 1); // admin privilege
            
            try {
                int affected = userStmt.executeUpdate();
                if (affected > 0) {
                    addedUsers++;
                    
                    // الحصول على ID المستخدم المضاف حديثاً
                    ResultSet rs = conn.createStatement().executeQuery("SELECT last_insert_rowid()");
                    if (rs.next()) {
                        int userId = rs.getInt(1);
                        
                        // إضافة إحصائيات
                        statsStmt.setInt(1, userId);
                        statsStmt.setInt(2, 5000);
                        statsStmt.setInt(3, 25);
                        statsStmt.executeUpdate();
                    }
                    rs.close();
                }
            } catch (SQLException e) {
                // تجاهل الأخطاء إذا كان المستخدم موجوداً
            }
        }
        
        userStmt.close();
        statsStmt.close();
        
        System.out.println("\n✅ تم إضافة " + addedUsers + " مستخدمين تجريبيين");
    }
}