package src5;

import com.smartfoxserver.v2.entities.data.SFSObject;
import java.util.ArrayDeque;
import java.util.ArrayList;
import java.util.Deque;
import java.util.List;

public class GlobalChatStore {
    private final Deque<SFSObject> messages = new ArrayDeque<>();
    private final int maxMessages;

    public GlobalChatStore(int maxMessages) {
        this.maxMessages = maxMessages;
    }

    public synchronized void addMessage(SFSObject payload) {
        if (payload == null) {
            return;
        }
        messages.addLast(payload);
        while (messages.size() > maxMessages) {
            messages.removeFirst();
        }
    }

    public synchronized List<SFSObject> getMessages() {
        return new ArrayList<>(messages);
    }
}
