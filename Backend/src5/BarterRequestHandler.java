package src5;

public class BarterRequestHandler extends SimpleAckHandler {

    @Override
    protected String commandName() {
        return "barterrequest";
    }
}
