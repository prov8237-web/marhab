package src5;

import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.data.ISFSObject;
import com.smartfoxserver.v2.entities.data.SFSObject;
import com.smartfoxserver.v2.extensions.BaseClientRequestHandler;
import java.util.ArrayList;
import java.util.List;

public class AnnouncementHandler extends BaseClientRequestHandler {
    
    private static List<Announcement> announcements = new ArrayList<>();
    private static int nextId = 1;
    
    @Override
    public void handleClientRequest(User user, ISFSObject params) {
        // الحصول على الأمر من الاسم المسجل
        String action = params.containsKey("action") ? params.getUtfString("action") : "list";
        
        switch (action) {
            case "create":
                createAnnouncement(user, params);
                break;
            case "update":
                updateAnnouncement(user, params);
                break;
            case "delete":
                deleteAnnouncement(user, params);
                break;
            case "list":
            default:
                listAnnouncements(user, params);
                break;
        }
    }
    
    private void createAnnouncement(User user, ISFSObject params) {
        if (user.getPrivilegeId() < 50) {
            sendError(user, "PERMISSION_DENIED", "Insufficient privileges");
            return;
        }
        
        if (!params.containsKey("title") || !params.containsKey("content")) {
            sendError(user, "MISSING_PARAM", "Title and content are required");
            return;
        }
        
        Announcement announcement = new Announcement();
        announcement.id = nextId++;
        announcement.title = params.getUtfString("title");
        announcement.content = params.getUtfString("content");
        announcement.author = user.getName();
        announcement.createdAt = System.currentTimeMillis();
        announcement.updatedAt = announcement.createdAt;
        announcement.priority = params.containsKey("priority") ? params.getInt("priority") : 1;
        announcement.active = params.containsKey("active") ? params.getBool("active") : true;
        
        if (params.containsKey("expiresAt")) {
            announcement.expiresAt = params.getLong("expiresAt");
        }
        
        announcements.add(announcement);
        
        // Broadcast new announcement if active
        if (announcement.active) {
            broadcastAnnouncement(announcement);
        }
        
        SFSObject response = new SFSObject();
        response.putUtfString("status", "success");
        response.putUtfString("message", "Announcement created");
        response.putInt("id", announcement.id);
        
        send("announcement", response, user);
        ((MainExtension) getParentExtension()).markResponseSent("announcement", user);
        
        SystemLogHandler.addLog("ANNOUNCEMENT", user.getName() + " created announcement: " + announcement.title);
    }
    
    private void listAnnouncements(User user, ISFSObject params) {
        boolean activeOnly = params.containsKey("activeOnly") && params.getBool("activeOnly");
        
        SFSObject response = new SFSObject();
        SFSObject announcementsData = new SFSObject();
        
        for (Announcement ann : announcements) {
            if (activeOnly && !ann.active) continue;
            
            SFSObject annData = new SFSObject();
            annData.putInt("id", ann.id);
            annData.putUtfString("title", ann.title);
            annData.putUtfString("content", ann.content);
            annData.putUtfString("author", ann.author);
            annData.putLong("createdAt", ann.createdAt);
            annData.putInt("priority", ann.priority);
            annData.putBool("active", ann.active);
            
            if (ann.expiresAt > 0) {
                annData.putLong("expiresAt", ann.expiresAt);
            }
            
            announcementsData.putSFSObject("ann_" + ann.id, annData);
        }
        
        response.putSFSObject("announcements", announcementsData);
        response.putUtfString("status", "success");
        response.putInt("count", activeOnly ? 
            (int) announcements.stream().filter(a -> a.active).count() : announcements.size());
        
        send("announcement", response, user);
        ((MainExtension) getParentExtension()).markResponseSent("announcement", user);
    }
    
    private void updateAnnouncement(User user, ISFSObject params) {
        if (user.getPrivilegeId() < 50) {
            sendError(user, "PERMISSION_DENIED", "Insufficient privileges");
            return;
        }
        
        if (!params.containsKey("id")) {
            sendError(user, "MISSING_PARAM", "Announcement ID is required");
            return;
        }
        
        int id = params.getInt("id");
        Announcement announcement = findAnnouncement(id);
        
        if (announcement == null) {
            sendError(user, "NOT_FOUND", "Announcement not found");
            return;
        }
        
        if (params.containsKey("title")) {
            announcement.title = params.getUtfString("title");
        }
        if (params.containsKey("content")) {
            announcement.content = params.getUtfString("content");
        }
        if (params.containsKey("priority")) {
            announcement.priority = params.getInt("priority");
        }
        if (params.containsKey("active")) {
            boolean newActive = params.getBool("active");
            if (newActive && !announcement.active) {
                broadcastAnnouncement(announcement);
            }
            announcement.active = newActive;
        }
        
        announcement.updatedAt = System.currentTimeMillis();
        
        SFSObject response = new SFSObject();
        response.putUtfString("status", "success");
        response.putUtfString("message", "Announcement updated");
        
        send("announcement", response, user);
        ((MainExtension) getParentExtension()).markResponseSent("announcement", user);
    }
    
    private void deleteAnnouncement(User user, ISFSObject params) {
        if (user.getPrivilegeId() < 50) {
            sendError(user, "PERMISSION_DENIED", "Insufficient privileges");
            return;
        }
        
        if (!params.containsKey("id")) {
            sendError(user, "MISSING_PARAM", "Announcement ID is required");
            return;
        }
        
        int id = params.getInt("id");
        Announcement announcement = findAnnouncement(id);
        
        if (announcement == null) {
            sendError(user, "NOT_FOUND", "Announcement not found");
            return;
        }
        
        announcements.remove(announcement);
        
        SFSObject response = new SFSObject();
        response.putUtfString("status", "success");
        response.putUtfString("message", "Announcement deleted");
        
        send("announcement", response, user);
        ((MainExtension) getParentExtension()).markResponseSent("announcement", user);
    }
    
    private void broadcastAnnouncement(Announcement announcement) {
        // Note: لن نستخدم getParentZone() مباشرة
        // يمكن إضافة المنطق المناسب هنا
    }
    
    private Announcement findAnnouncement(int id) {
        for (Announcement ann : announcements) {
            if (ann.id == id) {
                return ann;
            }
        }
        return null;
    }
    
    private void sendError(User user, String errorCode, String message) {
        SFSObject error = new SFSObject();
        error.putUtfString("status", "error");
        error.putUtfString("errorCode", errorCode);
        error.putUtfString("message", message);
        send("announcement", error, user);
    }
    
    private static class Announcement {
        int id;
        String title;
        String content;
        String author;
        long createdAt;
        long updatedAt;
        long expiresAt;
        int priority;
        boolean active;
    }
}