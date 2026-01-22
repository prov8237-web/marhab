package src5;

import com.smartfoxserver.v2.entities.User;
import java.util.Map;
import java.util.UUID;
import java.util.concurrent.ConcurrentHashMap;

public class BarterStore {
    private final Map<String, BarterSession> sessions = new ConcurrentHashMap<>();

    public BarterSession createSession(User sender, User receiver) {
        String id = UUID.randomUUID().toString();
        BarterSession session = new BarterSession(id, sender.getName(), receiver.getName());
        sessions.put(id, session);
        return session;
    }

    public BarterSession getSession(String id) {
        if (id == null) {
            return null;
        }
        return sessions.get(id);
    }

    public void removeSession(String id) {
        if (id == null) {
            return;
        }
        sessions.remove(id);
    }

    public static class BarterSession {
        private final String id;
        private final String senderId;
        private final String receiverId;

        public BarterSession(String id, String senderId, String receiverId) {
            this.id = id;
            this.senderId = senderId;
            this.receiverId = receiverId;
        }

        public String getId() {
            return id;
        }

        public String getSenderId() {
            return senderId;
        }

        public String getReceiverId() {
            return receiverId;
        }
    }
}
