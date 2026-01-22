package src5;

public class BarterServices {
    private static final BarterStore STORE = new BarterStore();

    public static BarterStore getStore() {
        return STORE;
    }
}
