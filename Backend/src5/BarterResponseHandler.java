package src5;

public class BarterResponseHandler extends SimpleAckHandler {

    @Override
    protected String commandName() {
        return "barterresponse";
    }
}
