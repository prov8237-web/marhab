package src5;

public class GlobalChatServices {
    private static final GlobalChatStore STORE = new GlobalChatStore(50);

    public static GlobalChatStore getStore() {
        return STORE;
    }
}
