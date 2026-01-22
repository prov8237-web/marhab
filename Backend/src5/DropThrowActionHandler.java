package src5;

public class DropThrowActionHandler extends SimpleAckHandler {

    @Override
    protected String commandName() {
        return "dropthrowaction";
    }
}
