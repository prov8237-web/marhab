package src5;

public class MessageDetailsHandler extends SimpleAckHandler {

    @Override
    protected String commandName() {
        return "messagedetails";
    }
}
