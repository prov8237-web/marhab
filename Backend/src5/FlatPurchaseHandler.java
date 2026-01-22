package src5;

public class FlatPurchaseHandler extends SimpleAckHandler {

    @Override
    protected String commandName() {
        return "flatpurchase";
    }
}
