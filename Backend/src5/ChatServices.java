package src5;

public class ChatServices {
    private static final ChatConfig CONFIG = ChatConfig.defaultConfig();
    private static final InMemoryChatStore STORE = new InMemoryChatStore(CONFIG.getRoomHistoryLimit());
    private static final ChatService SERVICE = new ChatService(CONFIG, STORE);

    private ChatServices() {
    }

    public static ChatService getService() {
        return SERVICE;
    }
}
