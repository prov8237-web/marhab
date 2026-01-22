package src5;

public class TransferResponseHandler extends SimpleAckHandler {

    @Override
    protected String commandName() {
        return "transferresponse";
    }
}
