package src5;

public class TransferRequestHandler extends SimpleAckHandler {

    @Override
    protected String commandName() {
        return "transferrequest";
    }
}
