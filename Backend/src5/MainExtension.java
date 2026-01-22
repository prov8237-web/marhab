package src5;

import com.smartfoxserver.v2.extensions.SFSExtension;
import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.data.ISFSObject;
import com.smartfoxserver.v2.entities.data.SFSObject;
import java.util.*;
import java.util.concurrent.ConcurrentHashMap;

public class MainExtension extends SFSExtension {
    
    private Set<String> registeredHandlers = new HashSet<>();
    private Map<String, Integer> commandStats = new ConcurrentHashMap<>();
    private Map<String, Object> serverConfig = new ConcurrentHashMap<>();
    private long creationTime;
    
    public void markResponseSent(String command, User user) {
        trace("✅ [RESPONSE-TRACKED] " + command + " for " + user.getName());
    }

    @Override
    public void init() {
        creationTime = System.currentTimeMillis();
        
        // ==================== تحميل الإعدادات ====================
        loadServerConfig();
        
        trace("════════════════════════════════════════════════════════");
        trace("🎮 MARHAB EXTENSION - OFFICIAL SERVER REPLICA v2.0");
        trace("📅 System Date: " + new Date());
        trace("⚙️ Server Config: " + serverConfig);
        trace("════════════════════════════════════════════════════════");
        
        // ==================== CORE HANDLERS ====================
        trace("📦 Registering CORE handlers...");
        registerHandler("config", ConfigHandler.class);
        registerHandler("init", InitHandler.class);
        registerHandler("baseclothes", BaseClothesHandler.class);
        registerHandler("savebaseclothes", SaveBaseClothesHandler.class);
        registerHandler("roomjoincomplete", RoomJoinCompleteHandler.class);
        registerHandler("chat", ChatHandler.class);
        registerHandler("whisper", WhisperHandler.class);
        registerHandler("chat.message", GlobalChatMessageHandler.class);
        registerHandler("globalchat.join", GlobalChatJoinHandler.class);
        registerHandler("globalchat.leave", GlobalChatLeaveHandler.class);
        registerHandler("chatballoon", ChatBalloonHandler.class);
        registerHandler("chatext", ChatExtensions.class);
        registerHandler("cachemgr", CacheManager.class);
        registerHandler("smiley", SmileyHandler.class);
        
        // ==================== BUDDY SYSTEM HANDLERS ====================
        trace("🤝 Registering BUDDY SYSTEM handlers...");
        // القائمة الأساسية للأصدقاء
        registerHandler("buddylist", BuddyListHandler.class);
        
        // عمليات نظام الأصدقاء
        registerHandler("addbuddy", BuddySystemHandler.class);
        registerHandler("removebuddy", BuddySystemHandler.class);
        registerHandler("buddylocate", BuddySystemHandler.class);
        registerHandler("buddyinvitelocation", BuddySystemHandler.class);
        registerHandler("buddyrespondinvitelocation", BuddySystemHandler.class);
        registerHandler("buddyacceptinvitegame", BuddySystemHandler.class);
        
        // إدارة الملف الشخصي والحالة
        registerHandler("changemood", BuddySystemHandler.class);
        registerHandler("changestatusmessage", BuddySystemHandler.class);
        registerHandler("changebuddyrating", BuddySystemHandler.class);
        registerHandler("addbuddyresponse", BuddySystemHandler.class);
        
        // ==================== DIAMOND TRANSFER HANDLERS ====================
        trace("💎 Registering DIAMOND TRANSFER handlers...");
        registerHandler("diamondtransferrequest", DiamondTransferHandler.class);
        registerHandler("diamondtransferresponse", DiamondTransferHandler.class);
        
        // ==================== INVENTORY HANDLERS ====================
        trace("🎒 Registering INVENTORY handlers...");
        registerHandler("clothlist", ClothListHandler.class);
        registerHandler("cardlist", CardListHandler.class);
        registerHandler("handitemlist", HandItemListHandler.class);
        
        // ==================== MOVEMENT HANDLERS ====================
        trace("🚶 Registering MOVEMENT handlers...");
        registerHandler("walkrequest", WalkRequestHandler.class);
        registerHandler("walkfinalrequest", WalkFinalRequestHandler.class);
        
        // ==================== CLOTHES HANDLERS ====================
        trace("👕 Registering CLOTHES handlers...");
        registerHandler("changeclothes", ChangeClothesHandler.class);
        registerHandler("usehanditem", UseHandItemHandler.class);
        
        // ==================== SMILEY HANDLERS ====================
        trace("😊 Registering SMILEY handlers...");
        registerHandler("smileylist", SmileyListHandler.class);
        // registerHandler("changesmiley", ChangeSmileyHandler.class); // مؤقتاً معطل
        
        // ==================== ACHIEVEMENT HANDLERS ====================
        trace("🏆 Registering ACHIEVEMENT handlers...");
        registerHandler("achievementlist", AchievementListHandler.class);
        registerHandler("profile", ProfileHandler.class);
        registerHandler("universelist", UniverseListHandler.class);
        registerHandler("questlist", QuestListHandler.class);
        
        // ==================== PING/PONG ====================
        trace("📡 Registering PING handlers...");
        registerHandler("ping", PingHandler.class);
        
        // ==================== DOOR HANDLERS ====================
        trace("🚪 Registering DOOR handlers...");
        registerHandler("teleport", TeleportHandler.class);
        registerHandler("usedoor", UseDoorHandler.class);
        registerHandler("usehousedoor", UseHouseDoorHandler.class);
        registerHandler("useobjectdoor", UseObjectDoorHandler.class);
        
        // ==================== EMPTY/UTILITY HANDLERS ====================
        trace("🛠️ Registering UTILITY handlers...");
        registerHandler("roles", RolesHandler.class);
        registerHandler("trace", TraceHandler.class);
        
        trace("🔐 Registering AUTH handlers...");
        registerHandler("login", AuthHandler.class);
        registerHandler("register", AuthHandler.class);
        registerHandler("changepassword", AuthHandler.class);

        trace("👑 Registering PERMISSION handlers...");
        registerHandler("setpermission", PermissionHandler.class);
        registerHandler("viewpermission", PermissionHandler.class);
        registerHandler("listpermissions", PermissionHandler.class);
        
        // ==================== NOTIFICATION HANDLERS ====================
        trace("🔔 Registering NOTIFICATION handlers...");
        // هذه الـ handlers للـ extensions (ليست requests مباشرة)
        // سيتم التعامل معها داخل الـ BuddySystemHandler
        // ==================== NEW SETTINGS HANDLERS ====================
trace("⚙️ Registering SETTINGS handlers...");
registerHandler("getsettings", SettingsHandler.class);
registerHandler("updatesettings", SettingsHandler.class);
registerHandler("resetsettings", SettingsHandler.class);
registerHandler("exportsettings", SettingsHandler.class);
registerHandler("importsettings", SettingsHandler.class);

// ==================== ADVANCED FEATURES HANDLERS ====================
trace("🚀 Registering ADVANCED FEATURES handlers...");
registerHandler("serverstats", ServerStatsHandler.class);
registerHandler("playerlist", PlayerListHandler.class);
registerHandler("systemlog", SystemLogHandler.class);
registerHandler("broadcast", BroadcastHandler.class);
registerHandler("kickuser", UserManagementHandler.class);
registerHandler("banuser", UserManagementHandler.class);
registerHandler("muteuser", UserManagementHandler.class);
registerHandler("announcement", AnnouncementHandler.class);

// ==================== SECURITY HANDLERS ====================
trace("🔒 Registering SECURITY handlers...");
registerHandler("validateuser", SecurityHandler.class);
registerHandler("sessioncheck", SecurityHandler.class);
registerHandler("antibotcheck", SecurityHandler.class);
registerHandler("ratelimit", SecurityHandler.class);

// ==================== HEALTH & DIAGNOSTICS HANDLERS ====================
trace("🏥 Registering HEALTH handlers...");
registerHandler("healthcheck", HealthCheckHandler.class);
registerHandler("diagnostics", DiagnosticsHandler.class);

// ==================== BACKUP HANDLERS ====================
trace("💾 Registering BACKUP handlers...");
registerHandler("backupdata", BackupHandler.class);
registerHandler("restoredata", BackupHandler.class);
        
        trace("════════════════════════════════════════════════════════");
        trace("✅ SUCCESSFULLY REGISTERED " + registeredHandlers.size() + " HANDLERS");
        trace("════════════════════════════════════════════════════════");
        
        // عرض جميع الـ commands المسجلة مصنفة
        printRegisteredCommandsByCategory();
        
        // تسجيل بدء التشغيل
        logSystemEvent("SERVER_START", "Extension initialized successfully");
    }
    
    private void loadServerConfig() {
        // تحميل الإعدادات من ملف التكوين أو قاعدة البيانات
        serverConfig.put("serverName", "Marhab Official Server");
        serverConfig.put("version", "2.0.0");
        serverConfig.put("maxPlayers", 1000);
        serverConfig.put("chatEnabled", true);
        serverConfig.put("tradingEnabled", true);
        serverConfig.put("diamondTransferEnabled", true);
        serverConfig.put("logLevel", "INFO");
        serverConfig.put("backupInterval", 3600); // ساعة
        serverConfig.put("sessionTimeout", 1800); // 30 دقيقة
        serverConfig.put("rateLimitEnabled", true);
        serverConfig.put("antiBotEnabled", true);
        serverConfig.put("maintenanceMode", false);
        serverConfig.put("debugMode", false);
    }
    
    private void registerHandler(String command, Class<?> handlerClass) {
        try {
            addRequestHandler(command, handlerClass);
            registeredHandlers.add(command);
            trace("📌 Registered: " + command);
        } catch (Exception e) {
            trace("❌ ERROR registering handler for " + command + ": " + e.getMessage());
            logSystemEvent("ERROR", "Failed to register handler: " + command + " - " + e.getMessage());
        }
    }
    
    private void printRegisteredCommandsByCategory() {
        trace("\n📋 REGISTERED COMMANDS BY CATEGORY:");
        trace("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
        
        // Core
        trace("🎮 CORE (" + countCommands("config|init|roomjoincomplete|savebaseclothes") + "):");
        trace("   " + getCommands("config|init|roomjoincomplete|savebaseclothes"));
        
        // Buddy System
        trace("🤝 BUDDY SYSTEM (" + countCommands("buddy|addbuddy|removebuddy|changemood") + "):");
        trace("   " + getCommands("buddy|addbuddy|removebuddy|changemood"));
        
        // Diamond Transfer
        trace("💎 DIAMOND TRANSFER (" + countCommands("diamond") + "):");
        trace("   " + getCommands("diamond"));
        
        // Inventory
        trace("🎒 INVENTORY (" + countCommands("list|cloth|card|handitem") + "):");
        trace("   " + getCommands("list|cloth|card|handitem"));
        
        // Movement
        trace("🚶 MOVEMENT (" + countCommands("walk") + "):");
        trace("   " + getCommands("walk"));
        
        // Clothes
        trace("👕 CLOTHES (" + countCommands("changeclothes|usehanditem") + "):");
        trace("   " + getCommands("changeclothes|usehanditem"));
        
        // Smiley
        trace("😊 SMILEY (" + countCommands("smiley") + "):");
        trace("   " + getCommands("smiley"));
        
        // Achievement
        trace("🏆 ACHIEVEMENT (" + countCommands("achievement|profile|universe|quest") + "):");
        trace("   " + getCommands("achievement|profile|universe|quest"));
        
        // Ping
        trace("📡 PING (" + countCommands("ping") + "):");
        trace("   " + getCommands("ping"));
        
        // Door
        trace("🚪 DOOR (" + countCommands("door|teleport|use.*door") + "):");
        trace("   " + getCommands("door|teleport|use.*door"));
        
        // Utility
        trace("🛠️ UTILITY (" + countCommands("roles|trace|baseclothes") + "):");
        trace("   " + getCommands("roles|trace|baseclothes"));
        
        trace("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
        trace("📊 TOTAL COMMANDS: " + registeredHandlers.size());
        trace("════════════════════════════════════════════════════════\n");
    }
    
    private int countCommands(String pattern) {
        int count = 0;
        for (String cmd : registeredHandlers) {
            if (cmd.matches(".*(" + pattern + ").*")) {
                count++;
            }
        }
        return count;
    }
    
    private String getCommands(String pattern) {
        List<String> matching = new ArrayList<>();
        for (String cmd : registeredHandlers) {
            if (cmd.matches(".*(" + pattern + ").*")) {
                matching.add(cmd);
            }
        }
        Collections.sort(matching);
        return String.join(", ", matching);
    }

    @Override
    public void handleClientRequest(String requestId, User user, ISFSObject params) {
        // التحقق من وضع الصيانة
        if ((Boolean) serverConfig.getOrDefault("maintenanceMode", false) && 
            !isAdminRequest(requestId, user)) {
            sendMaintenanceResponse(requestId, user);
            return;
        }
        
        commandStats.merge(requestId, 1, Integer::sum);
        
        trace("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
        trace("📥 CLIENT REQUEST: " + requestId);
        trace("👤 User: " + user.getName());
        trace("📍 IP: " + user.getSession().getAddress());
        trace("🔑 User ID: " + user.getId());
        trace("🏠 Room: " + (user.getLastJoinedRoom() != null ? user.getLastJoinedRoom().getName() : "None"));
        
        // تسجيل إحصاءات الطلبات
        int totalRequests = commandStats.values().stream().mapToInt(Integer::intValue).sum();
        trace("📊 Request #" + commandStats.getOrDefault(requestId, 0) + 
              " of this type | Total: " + totalRequests);
        
        if (!registeredHandlers.contains(requestId)) {
            trace("⚠️ UNREGISTERED COMMAND: " + requestId);
            trace("💡 Available commands: " + registeredHandlers);
            
            // للطلب غير المسجل، نرسل رداً فارغاً لتجنب الخطأ
            send(requestId, new SFSObject(), user);
            return;
        }
        
        if (params != null && params.size() > 0) {
            trace("📋 Params (" + params.size() + "):");
            trace(params.getDump());
        } else {
            trace("📋 Params: Empty");
        }
        
        trace("⏳ Processing...");
        trace("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
        
        // تسجيل وقت بدء المعالجة
        long startTime = System.currentTimeMillis();
        
        try {
            super.handleClientRequest(requestId, user, params);
            
            // حساب وقت المعالجة
            long processingTime = System.currentTimeMillis() - startTime;
            trace("✅ [" + requestId + "] Processed in " + processingTime + "ms");
            trace("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n");
            
            // تسجيل وقت المعالجة الطويلة
            if (processingTime > 1000) { // أكثر من ثانية
                logSystemEvent("SLOW_REQUEST", requestId + " took " + processingTime + "ms for user " + user.getName());
            }
            
        } catch (Exception e) {
            trace("❌ ERROR processing " + requestId + ": " + e.getMessage());
            e.printStackTrace();
            
            // تسجيل الخطأ
            logSystemEvent("ERROR", "Failed to process " + requestId + " for user " + user.getName() + ": " + e.getMessage());
            
            // إرسال رد خطأ للعميل
            SFSObject errorRes = new SFSObject();
            errorRes.putUtfString("error", "SERVER_ERROR");
            errorRes.putUtfString("message", e.getMessage());
            errorRes.putInt("errorCode", 500);
            errorRes.putLong("timestamp", System.currentTimeMillis());
            send(requestId, errorRes, user);
        }
    }
    
    @Override
    public void destroy() {
        trace("════════════════════════════════════════════════════════");
        trace("🔴 EXTENSION SHUTTING DOWN");
        trace("📊 REQUEST STATISTICS:");
        
        // عرض إحصائيات الطلبات
        List<Map.Entry<String, Integer>> sortedStats = new ArrayList<>(commandStats.entrySet());
        sortedStats.sort((a, b) -> b.getValue().compareTo(a.getValue()));
        
        for (Map.Entry<String, Integer> entry : sortedStats) {
            trace("   " + entry.getKey() + ": " + entry.getValue() + " requests");
        }
        
        trace("👋 Total unique commands: " + commandStats.size());
        trace("⏰ System ran for: " + getUptime() + "ms (" + formatUptime(getUptime()) + ")");
        trace("════════════════════════════════════════════════════════");
        
        // تسجيل إيقاف التشغيل
        logSystemEvent("SERVER_SHUTDOWN", "Extension shutting down after " + getUptime() + "ms");
        
        super.destroy();
    }
    
    public long getCreationTime() {
    return creationTime;
}
    
    public long getUptime() {
        return System.currentTimeMillis() - creationTime;
    }
    
    private String formatUptime(long millis) {
        long seconds = millis / 1000;
        long minutes = seconds / 60;
        long hours = minutes / 60;
        long days = hours / 24;
        
        return String.format("%d days, %d hours, %d minutes, %d seconds", 
            days, hours % 24, minutes % 60, seconds % 60);
    }
    
    private boolean isAdminRequest(String requestId, User user) {
        // التحقق مما إذا كان المستخدم مسؤولاً أو الطلب مسموحاً أثناء الصيانة
        List<String> allowedDuringMaintenance = Arrays.asList(
            "ping", "trace", "config"
        );
        
        return allowedDuringMaintenance.contains(requestId) || 
               user.getPrivilegeId() >= 100; // مسؤول
    }
    
    private void sendMaintenanceResponse(String requestId, User user) {
        SFSObject response = new SFSObject();
        response.putUtfString("error", "MAINTENANCE_MODE");
        response.putUtfString("message", "Server is under maintenance. Please try again later.");
        response.putInt("errorCode", 503);
        response.putLong("estimatedRestoreTime", System.currentTimeMillis() + 3600000); // ساعة
        send(requestId, response, user);
        
        logSystemEvent("MAINTENANCE_BLOCK", "Request blocked for user " + user.getName() + ": " + requestId);
    }
    
    private void logSystemEvent(String eventType, String message) {
        // تسجيل الأحداث في سجل النظام
        String logEntry = String.format("[%s] [%s] %s", 
            new Date(), eventType, message);
        
        // يمكن إضافة تخزين في قاعدة البيانات هنا
        trace("📝 SYSTEM LOG: " + logEntry);
    }
    
    // طريقة مساعدة للحصول على إحصائيات الطلبات
    public Map<String, Integer> getCommandStats() {
        return new HashMap<>(commandStats);
    }
    
    // طريقة مساعدة للتحقق من وجود handler
    public boolean hasHandler(String command) {
        return registeredHandlers.contains(command);
    }
    
    // طريقة لإضافة handler ديناميكي
    public void addDynamicHandler(String command, Class<?> handlerClass) {
        registerHandler(command, handlerClass);
        trace("🔄 Dynamically added handler: " + command);
        logSystemEvent("DYNAMIC_HANDLER", "Added handler: " + command);
    }
    
    // طريقة للحصول على إعدادات الخادم
    public Map<String, Object> getServerConfig() {
        return new HashMap<>(serverConfig);
    }
    
    // طريقة لتحديث إعدادات الخادم
    public void updateServerConfig(String key, Object value) {
        serverConfig.put(key, value);
        trace("⚙️ Updated server config: " + key + " = " + value);
        logSystemEvent("CONFIG_UPDATE", "Updated " + key + " to " + value);
    }
    
    // طريقة للحصول على حالة الخادم
    public SFSObject getServerStatus() {
        SFSObject status = new SFSObject();
        status.putLong("uptime", getUptime());
        status.putInt("totalCommands", registeredHandlers.size());
        status.putInt("activeUsers", getParentZone().getUserCount());
        status.putInt("totalRequests", commandStats.values().stream().mapToInt(Integer::intValue).sum());
        status.putBool("maintenanceMode", (Boolean) serverConfig.getOrDefault("maintenanceMode", false));
        status.putLong("timestamp", System.currentTimeMillis());
        return status;
    }
}
