package src5;

public class PurchaseHandler extends SimpleAckHandler {

    @Override
    protected String commandName() {
        return "purchase";
    }
}
