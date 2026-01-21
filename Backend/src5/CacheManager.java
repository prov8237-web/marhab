package src5;

import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.data.*;
import java.util.HashMap;
import java.util.Map;

public class CacheManager extends OsBaseHandler {
    
    private Map<String, CacheEntry> characterCache = new HashMap<>();
    private Map<String, Boolean> compatibilityCache = new HashMap<>();
    
    @Override
    public void handleClientRequest(User user, ISFSObject params) {
        String action = params.getUtfString("action");
        
        trace("[CACHE] Request from: " + user.getName() + ", action: " + action);
        
        switch (action) {
            case "checkCompatibility":
                checkCompatibility(user, params);
                break;
                
            case "getCachedCharacter":
                getCachedCharacter(user, params);
                break;
                
            case "clearCache":
                clearUserCache(user, params);
                break;
                
            case "getCacheStats":
                getCacheStats(user);
                break;
                
            default:
                trace("[CACHE] ❌ Unknown action: " + action);
                sendError(user, "UNKNOWN_ACTION");
        }
    }
    
    private void checkCompatibility(User user, ISFSObject params) {
        String characterId = params.getUtfString("characterId");
        String animationType = params.getUtfString("animationType");
        String cacheKey = generateCacheKey(user.getName(), characterId, animationType);
        
        // التحقق إذا كان العنصر متوافقاً مع التخزين المؤقت
        boolean isCompatible = checkCharacterCompatibility(characterId, animationType);
        
        // تخزين النتيجة في الذاكرة
        compatibilityCache.put(cacheKey, isCompatible);
        
        // إرسال الرد
        SFSObject response = new SFSObject();
        response.putBool("isCompatible", isCompatible);
        response.putUtfString("cacheKey", cacheKey);
        
        send("cacheCompatibilityResult", response, user);
        trace("[CACHE] Compatibility check: " + cacheKey + " = " + isCompatible);
    }
    
    private void getCachedCharacter(User user, ISFSObject params) {
        String cacheKey = params.getUtfString("cacheKey");
        
        // استخدام القيمة الافتراضية إذا لم يكن المعامل موجوداً
        boolean useOptimized = true;
        if (params.containsKey("optimized")) {
            useOptimized = params.getBool("optimized");
        }
        
        trace("[CACHE] Retrieving cached character: " + cacheKey + ", optimized: " + useOptimized);
        
        CacheEntry cachedEntry = characterCache.get(cacheKey);
        
        if (cachedEntry != null && !cachedEntry.isExpired()) {
            // العنصر موجود في الذاكرة المؤقتة
            sendCachedData(user, cachedEntry);
        } else {
            // إنشاء نسخة مؤقتة جديدة
            createNewCacheEntry(user, cacheKey, useOptimized);
        }
    }
    
    private void createNewCacheEntry(User user, String cacheKey, boolean optimized) {
        trace("[CACHE] Creating new cache entry: " + cacheKey);
        
        // فك تشفير مفتاح الذاكرة المؤقتة
        String[] parts = cacheKey.split("_");
        if (parts.length < 3) {
            sendError(user, "INVALID_CACHE_KEY");
            return;
        }
        
        String username = parts[0];
        String characterId = parts[1];
        String animationType = parts[2];
        
        // الحصول على بيانات الشخصية
        ISFSObject characterData = getCharacterData(user, characterId);
        
        if (characterData == null) {
            sendError(user, "CHARACTER_NOT_FOUND");
            return;
        }
        
        // معالجة الصورة وتحويلها إلى صيغة مناسبة للتخزين المؤقت
        ISFSObject processedData = processCharacterForCache(characterData, animationType, optimized);
        
        // إنشاء إدخال جديد في الذاكرة المؤقتة
        CacheEntry newEntry = new CacheEntry(cacheKey, processedData);
        characterCache.put(cacheKey, newEntry);
        
        // إرسال البيانات للمستخدم
        sendCachedData(user, newEntry);
        
        trace("[CACHE] ✅ New cache entry created: " + cacheKey);
    }
    
    private void sendCachedData(User user, CacheEntry entry) {
        SFSObject response = new SFSObject();
        response.putUtfString("cacheKey", entry.getKey());
        response.putSFSObject("characterData", entry.getData());
        response.putInt("width", entry.getWidth());
        response.putInt("height", entry.getHeight());
        response.putLong("createdAt", entry.getCreatedAt());
        response.putLong("expiresAt", entry.getExpiresAt());
        
        send("cachedCharacterData", response, user);
        trace("[CACHE] Sent cached data for: " + entry.getKey());
    }
    
    private void clearUserCache(User user, ISFSObject params) {
        String username = user.getName();
        int clearedCount = 0;
        
        // حذف جميع المدخلات المتعلقة بهذا المستخدم
        for (String key : characterCache.keySet()) {
            if (key.startsWith(username + "_")) {
                characterCache.remove(key);
                clearedCount++;
            }
        }
        
        // حذف من ذاكرة التوافق أيضاً
        for (String key : compatibilityCache.keySet()) {
            if (key.startsWith(username + "_")) {
                compatibilityCache.remove(key);
            }
        }
        
        SFSObject response = new SFSObject();
        response.putInt("clearedCount", clearedCount);
        
        send("cacheCleared", response, user);
        trace("[CACHE] Cleared " + clearedCount + " cache entries for: " + username);
    }
    
    private void getCacheStats(User user) {
        SFSObject response = new SFSObject();
        response.putInt("totalCachedCharacters", characterCache.size());
        response.putInt("totalCompatibilityChecks", compatibilityCache.size());
        response.putInt("memoryUsage", calculateMemoryUsage());
        
        send("cacheStats", response, user);
        trace("[CACHE] Sent cache stats to: " + user.getName());
    }
    
    private boolean checkCharacterCompatibility(String characterId, String animationType) {
        // منطق التحقق من التوافق
        // يمكن التحقق من:
        // 1. نوع الرسوم المتحركة (يجب أن يكون ثابتاً)
        // 2. وجود العناصر المتحركة
        // 3. نوع الملابس والأدوات
        
        // مؤقتاً، نفترض أن جميع الشخصيات متوافقة مع وضع "idle"
        return "idle".equals(animationType) || "stand".equals(animationType);
    }
    
    private ISFSObject getCharacterData(User user, String characterId) {
        // الحصول على بيانات الشخصية من قاعدة البيانات أو المتغيرات
        // هذا مثال بسيط:
        SFSObject characterData = new SFSObject();
        characterData.putUtfString("id", characterId);
        characterData.putUtfString("name", user.getName());
        characterData.putUtfString("gender", user.getVariable("gender").getStringValue());
        characterData.putUtfString("clothes", user.getVariable("clothes").getStringValue());
        
        return characterData;
    }
    
    private ISFSObject processCharacterForCache(ISFSObject characterData, String animationType, boolean optimized) {
        // هنا يتم معالجة بيانات الشخصية للتخزين المؤقت
        // في الواقع، يجب تحويل الرسوميات إلى صيغة مناسبة
        
        SFSObject processed = new SFSObject();
        processed.putUtfString("id", characterData.getUtfString("id"));
        processed.putUtfString("name", characterData.getUtfString("name"));
        processed.putUtfString("animationType", animationType);
        processed.putBool("optimized", optimized);
        processed.putUtfString("status", "cached");
        processed.putLong("cacheTime", System.currentTimeMillis());
        
        // إضافة معلومات الأبعاد (محاكاة)
        processed.putInt("width", 150);
        processed.putInt("height", 200);
        
        return processed;
    }
    
    private int calculateMemoryUsage() {
        // حساب الاستخدام التقريبي للذاكرة
        return characterCache.size() * 50; // 50KB لكل مدخل تقريباً
    }
    
    private String generateCacheKey(String username, String characterId, String animationType) {
        return username + "_" + characterId + "_" + animationType;
    }
    
    private void sendError(User user, String error) {
        SFSObject errorResponse = new SFSObject();
        errorResponse.putUtfString("error", error);
        
        send("cacheError", errorResponse, user);
        trace("[CACHE] ❌ Error: " + error + " for user: " + user.getName());
    }
    
    // فئة مساعدة لإدخال الذاكرة المؤقتة
    private class CacheEntry {
        private String key;
        private ISFSObject data;
        private long createdAt;
        private long expiresAt;
        
        public CacheEntry(String key, ISFSObject data) {
            this.key = key;
            this.data = data;
            this.createdAt = System.currentTimeMillis();
            this.expiresAt = this.createdAt + (30 * 60 * 1000); // 30 دقيقة
        }
        
        public String getKey() { return key; }
        public ISFSObject getData() { return data; }
        public long getCreatedAt() { return createdAt; }
        public long getExpiresAt() { return expiresAt; }
        
        public boolean isExpired() {
            return System.currentTimeMillis() > expiresAt;
        }
        
        public int getWidth() {
            return data.getInt("width");
        }
        
        public int getHeight() {
            return data.getInt("height");
        }
    }
}