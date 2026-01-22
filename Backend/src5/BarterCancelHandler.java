package src5;

public class BarterCancelHandler extends SimpleAckHandler {

    @Override
    protected String commandName() {
        return "bartercancel";
    }
}
