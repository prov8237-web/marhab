package src5;

import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.data.*;
import com.smartfoxserver.v2.entities.variables.*;
import java.nio.charset.StandardCharsets;
import java.util.*;
import com.smartfoxserver.v2.exceptions.SFSJoinRoomException;

public class InitHandler extends OsBaseHandler {

    @Override
    public void handleClientRequest(User user, ISFSObject params) {
        String userIP = user.getSession().getAddress();
        
        trace("[INIT] ═══════════════════════════════════════════════════");
        trace("[INIT] Request from IP: " + userIP);

        // ✅ منح صلاحيات أدمن لكل المستخدمين الجدد
        // إذا كان المستخدم ضيفاً، نمنحه صلاحيات أدمن
        short currentPrivilege = user.getPrivilegeId();
        trace("[INIT] Current privilege for " + user.getName() + ": " + currentPrivilege);
        
        if (currentPrivilege < 100) { // أقل من أدمن
            short adminPrivilege = 100; // ⚠️ استخدم short بدلاً من int
            user.setPrivilegeId(adminPrivilege); // ✅ الآن short
            trace("[INIT] ⭐ Elevated guest to ADMIN privileges: " + user.getName());
            trace("[INIT] New privilege: " + user.getPrivilegeId());
        }
        
        // الحصول على أو إنشاء PlayerID
        String customID;
        if (getParentExtension().getParentZone().containsProperty(userIP + "_id")) {
            customID = (String) getParentExtension().getParentZone().getProperty(userIP + "_id");
            trace("[INIT] Found existing ID: " + customID);
        } else {
            customID = String.valueOf(System.currentTimeMillis());
            getParentExtension().getParentZone().setProperty(userIP + "_id", customID);
            trace("[INIT] Created new ID: " + customID);
        }
        
        long ts = System.currentTimeMillis() / 1000;
        double playerIDDouble = Double.parseDouble(customID);
        
        // التحقق مما إذا كان المستخدم لديه بيانات محفوظة
        boolean hasSavedData = getParentExtension().getParentZone().containsProperty(userIP + "_active");
        trace("[INIT] Has saved data: " + hasSavedData);
        
        // ═══════════════════════════════════════════════════════════
        // STEP 1: Send initQueue أولاً
        // ═══════════════════════════════════════════════════════════
        SFSObject initQueueRes = new SFSObject();
        initQueueRes.putInt("p", 1);
        initQueueRes.putLong("ts", ts);
        send("initQueue", initQueueRes, user);
        trace("[INIT] Sent initQueue");
        
        // ═══════════════════════════════════════════════════════════
        // STEP 2: تعيين User Variables - مهم لظهور الشخصية
        // ═══════════════════════════════════════════════════════════
        String savedGender = "m";
        String savedName = "Guest";
        
        // إذا كان المستخدم لديه صلاحيات أدمن، غير الاسم
        if (user.getPrivilegeId() >= 100) {
            savedName = "AdminGuest";
        }
        
        if (hasSavedData) {
            Object genderObj = getParentExtension().getParentZone().getProperty(userIP + "_gender");
            Object nameObj = getParentExtension().getParentZone().getProperty(userIP + "_name");
            if (genderObj != null) savedGender = (String) genderObj;
            if (nameObj != null) savedName = (String) nameObj;
            trace("[INIT] Loaded saved gender: " + savedGender + ", name: " + savedName);
        }
        
        // بناء JSON الملابس لمتغير المستخدم
        String clothesJson = "[]";
        ISFSArray savedItemsArray = null;
        
        if (hasSavedData) {
            Object clothesObj = getParentExtension().getParentZone().getProperty(userIP + "_clothes");
            
            if (clothesObj != null && clothesObj instanceof ISFSObject) {
                ISFSObject savedClothes = (ISFSObject) clothesObj;
                
                if (savedClothes.containsKey("items")) {
                    savedItemsArray = savedClothes.getSFSArray("items");
                    clothesJson = savedItemsArray.toJson();
                    trace("[INIT] Found " + savedItemsArray.size() + " clothing items");
                }
            }
        }
        
        List<UserVariable> userVars = new ArrayList<>();
        userVars.add(new SFSUserVariable("gender", savedGender));
        userVars.add(new SFSUserVariable("playerID", playerIDDouble));
        userVars.add(new SFSUserVariable("avatarName", savedName));
        userVars.add(new SFSUserVariable("universeKey", "w1"));
        userVars.add(new SFSUserVariable("imgPath", ""));
        userVars.add(new SFSUserVariable("mood", 0));
        userVars.add(new SFSUserVariable("platform", "web"));
        
        // ✅ رسالة حالة خاصة للمستخدمين الذين لديهم صلاحيات أدمن
        String statusMessage = "Welcome!";
        if (user.getPrivilegeId() >= 100) {
            statusMessage = "⭐ Admin Guest ⭐";
        }
        userVars.add(new SFSUserVariable("statusMessage", statusMessage));
        
        userVars.add(new SFSUserVariable("hand", ""));
        userVars.add(new SFSUserVariable("speed", 1.0));
        userVars.add(new SFSUserVariable("smiley", "empty"));
        userVars.add(new SFSUserVariable("avatarSize", 5.0));
        userVars.add(new SFSUserVariable("clothes", clothesJson));
        
        try {
            getApi().setUserVariables(user, userVars);
            trace("[INIT] ✅ Set user variables successfully");
        } catch (Exception e) {
            trace("[INIT] ❌ ERROR setting user variables: " + e.getMessage());
        }
        
        // تعيين متغير roles بشكل منفصل
        List<UserVariable> rolesVar = new ArrayList<>();
        rolesVar.add(new SFSUserVariable("roles", "Pg=="));
        getApi().setUserVariables(user, rolesVar);
        
        // ═══════════════════════════════════════════════════════════
        // STEP 3: إرسال استجابة roles
        // ═══════════════════════════════════════════════════════════
        SFSObject rolesRes = new SFSObject();
        rolesRes.putUtfString("roles", "Pg==");
        send("roles", rolesRes, user);
        trace("[INIT] Sent roles");
        
        // ═══════════════════════════════════════════════════════════
        // STEP 4: تعيين متغيرات الموضع - مهم جداً لظهور الشخصية
        // ═══════════════════════════════════════════════════════════
        List<UserVariable> posVars = new ArrayList<>();
        posVars.add(new SFSUserVariable("target", ""));
        getApi().setUserVariables(user, posVars);
        
        List<UserVariable> statusVars = new ArrayList<>();
        statusVars.add(new SFSUserVariable("status", "idle"));
        statusVars.add(new SFSUserVariable("position", "50,50")); // ✅ موضع ثابت للبداية
        statusVars.add(new SFSUserVariable("direction", "0"));
        getApi().setUserVariables(user, statusVars);
        
        // ═══════════════════════════════════════════════════════════
        // STEP 5: تعيين متغيرات الغرفة الضرورية قبل الانضمام
        // ═══════════════════════════════════════════════════════════
        com.smartfoxserver.v2.entities.Room targetRoom = getParentExtension().getParentZone().getRoomByName("street01");
        if (targetRoom != null) {
            // تعيين متغيرات الغرفة الضرورية
            List<RoomVariable> roomVars = new ArrayList<>();
            roomVars.add(new SFSRoomVariable("roomKey", "street01"));
            roomVars.add(new SFSRoomVariable("width", 850));
            roomVars.add(new SFSRoomVariable("height", 500));
            roomVars.add(new SFSRoomVariable("type", "OUTDOOR"));
            roomVars.add(new SFSRoomVariable("roomTitle", "الشارع الرئيسي"));
            roomVars.add(new SFSRoomVariable("chatBalloon", 1)); // ✅ مهم لظهور فقاعة المحادثة
            roomVars.add(new SFSRoomVariable("allowWalk", true));
            roomVars.add(new SFSRoomVariable("allowChat", true));
            roomVars.add(new SFSRoomVariable("allowTrade", false));
            roomVars.add(new SFSRoomVariable("minimap", "street01"));
            roomVars.add(new SFSRoomVariable("theme", "snow"));
            
            getApi().setRoomVariables(null, targetRoom, roomVars);
            trace("[INIT] ✅ Set room variables for street01");
            
            // الانضمام للغرفة
            if (user.getLastJoinedRoom() == null) {
                try {
                    getApi().joinRoom(user, targetRoom);
                    trace("[INIT] ✅ Joined room: street01");
                } catch (SFSJoinRoomException e) {
                    trace("[INIT] ❌ ERROR joining room: " + e.getMessage());
                }
            }
        } else {
            trace("[INIT] ❌ ERROR: Target room street01 not found in zone");
        }
        
        // ═══════════════════════════════════════════════════════════
        // STEP 6: إرسال questlistroom
        // ═══════════════════════════════════════════════════════════
        SFSObject questRes = new SFSObject();
        SFSArray questsArray = new SFSArray();
        
        SFSObject quest = new SFSObject();
        quest.putInt("rewardMultiplier", 1);
        quest.putUtfString("metaKey", "paperDelivery");
        quest.putInt("id", -(int)(Math.random() * 100000));
        quest.putUtfString("status", "NEW");
        quest.putInt("currentStep", 1);
        quest.putInt("totalStep", 7);
        quest.putUtfString("roomKey", "street01");
        
        SFSObject step = new SFSObject();
        step.putUtfString("cn", "BotQuestProperty");
        step.putUtfString("botKey", "tahsin");
        step.putInt("reqVal", 1);
        step.putInt("curVal", 0);
        
        SFSArray items = new SFSArray();
        SFSObject item = new SFSObject();
        item.putInt("quantity", 5);
        item.putUtfString("countDownType", "NOW");
        item.putInt("lifeTime", 85443);
        item.putUtfString("clip", "dt678TPO");
        items.addSFSObject(item);
        step.putSFSArray("items", items);
        quest.putSFSObject("step", step);
        
        SFSArray rewards = new SFSArray();
        SFSObject reward = new SFSObject();
        reward.putUtfString("type", "SANIL");
        SFSObject rewardData = new SFSObject();
        rewardData.putInt("amount", 999990);
        reward.putSFSObject("data", rewardData);
        rewards.addSFSObject(reward);
        quest.putSFSArray("rewards", rewards);
        
        questsArray.addSFSObject(quest);
        questRes.putSFSArray("quests", questsArray);
        send("questlistroom", questRes, user);
        trace("[INIT] Sent questlistroom");
        
        // ═══════════════════════════════════════════════════════════
        // STEP 7: إرسال استجابة init الرئيسية
        // ═══════════════════════════════════════════════════════════
        SFSObject res = new SFSObject();
        res.putLong("ts", ts);
        res.putUtfString("playerID", customID);
        res.putUtfString("selectedAvatarID", customID);
        res.putInt("emailActive", 1);
        res.putBool("guest", !hasSavedData);
        res.putBool("isBanned", false);
        res.putInt("completedAchievementsCount", 1);
        res.putInt("tutorialStep", 1);
        res.putBool("dailySpinAvailable", false);
        res.putSFSArray("campaigns", new SFSArray());
        res.putSFSArray("bans", new SFSArray());
        res.putSFSObject("settings", new SFSObject());
        res.putUtfString("gender", savedGender);
        
        if (!hasSavedData) {
            res.putBool("createAvatar", true);
            trace("[INIT] Added createAvatar: true for new user");
        } else {
            trace("[INIT] User has saved data, no createAvatar field");
        }
        
        res.putInt("checkAvatar", hasSavedData ? 1 : 0);
        trace("[INIT] checkAvatar = " + (hasSavedData ? 1 : 0));
        
        // Universe
        SFSObject universe = new SFSObject();
        universe.putUtfString("key", "w1");
        universe.putUtfString("name", "جزيرة 1");
        universe.putInt("fullness", 10);
        universe.putInt("roomFullness", 0);
        universe.putBool("roomAvailable", true);
        universe.putBool("recommended", false);
        universe.putUtfString("roles", "AA==");
        res.putSFSObject("universe", universe);

        // Wallet - زيادة الرصيد للضيوف
        SFSArray walletArray = new SFSArray();
        
        SFSObject sanilWallet = new SFSObject();
        sanilWallet.putUtfString("currency", "SANIL");
        // ✅ رصيد أكبر للمستخدمين الجدد
        int sanilBalance = hasSavedData ? 60 : 999999;
        if (user.getPrivilegeId() >= 100) {
            sanilBalance = 9999999; // رصيد ضخم للـ Admin
        }
        sanilWallet.putInt("balance", sanilBalance);
        sanilWallet.putDouble("avatarID", playerIDDouble);
        walletArray.addSFSObject(sanilWallet);
        
        SFSObject diamondWallet = new SFSObject();
        diamondWallet.putUtfString("currency", "DIAMOND");
        int diamondBalance = 9999;
        if (user.getPrivilegeId() >= 100) {
            diamondBalance = 99999;
        }
        diamondWallet.putInt("balance", diamondBalance);
        diamondWallet.putDouble("avatarID", playerIDDouble);
        walletArray.addSFSObject(diamondWallet);
        
        res.putSFSArray("wallet", walletArray);
        
        // Room data
        SFSObject roomObj = new SFSObject();
        roomObj.putUtfString("key", "street01");
        roomObj.putUtfString("doorKey", "d5");
        roomObj.putInt("pv", 0);
        roomObj.putInt("dv", 0);
        
        String streetMap = "<map themes=\"snow\" xOrigin=\"275\" yOrigin=\"614\">" +
                          "<billboard h=\"67\" skew=\"0.33\" w=\"160\" x=\"452\" y=\"5\" z=\"0\"/>" +
                          "<floor d=\"1\" def=\"mcSign_19\" dir=\"0\" if=\"haxe\" pt=\"free\" w=\"1\" x=\"-3\" y=\"0\" z=\"0\"/>" +
                          "</map>";
        roomObj.putUtfString("map", Base64.getEncoder().encodeToString(streetMap.getBytes(StandardCharsets.UTF_8)));
        res.putSFSObject("room", roomObj);

        // Clothes
        SFSObject clothesObjResponse = new SFSObject();
        
        if (hasSavedData && savedItemsArray != null && savedItemsArray.size() > 0) {
            clothesObjResponse.putUtfString("type", "CLOTH");
            clothesObjResponse.putSFSArray("items", savedItemsArray);
            trace("[INIT] ✅ Adding " + savedItemsArray.size() + " items to response");
        } else {
            clothesObjResponse.putSFSArray("items", new SFSArray());
            clothesObjResponse.putUtfString("type", "CLOTH");
            trace("[INIT] Empty clothes (new user or no saved items)");
        }
        res.putSFSObject("clothes", clothesObjResponse);

        // Extension info
        SFSArray extInfo = new SFSArray();
        
        SFSObject cursorExt = new SFSObject();
        cursorExt.putUtfString("name", "CursorExtension");
        cursorExt.putSFSObject("property", new SFSObject());
        extInfo.addSFSObject(cursorExt);
        
        SFSObject soundExt = new SFSObject();
        soundExt.putUtfString("name", "SoundExtension");
        soundExt.putSFSObject("property", new SFSObject());
        extInfo.addSFSObject(soundExt);
        
        SFSObject snowExt = new SFSObject();
        snowExt.putUtfString("name", "SnowExtension");
        SFSObject snowProp = new SFSObject();
        snowProp.putUtfString("cn", "SnowExtensionProperty");
        snowProp.putUtfString("type", "outdoor");
        snowProp.putInt("speed", 2);
        snowExt.putSFSObject("property", snowProp);
        extInfo.addSFSObject(snowExt);
        
        res.putSFSArray("extensionInfo", extInfo);

        send("init", res, user);
        trace("[INIT] Sent main init response");
        
        // ═══════════════════════════════════════════════════════════
        // STEP 8: إرسال باقي الاستجابات
        // ═══════════════════════════════════════════════════════════
        SFSObject restartRes = new SFSObject();
        restartRes.putBool("isRestartWaiting", false);
        send("restartServer", restartRes, user);
        trace("[INIT] Sent restartServer");
        
        SFSObject chatUpdateRes = new SFSObject();
        chatUpdateRes.putInt("unreadMessages", 0);
        send("privateChatUpdate", chatUpdateRes, user);
        trace("[INIT] Sent privateChatUpdate");
        
        trace("[INIT] ✅ Complete for: " + user.getName());
        trace("[INIT] ═══════════════════════════════════════════════════");
    }
}