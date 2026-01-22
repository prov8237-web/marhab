package src5;

public class DropHandler extends SimpleAckHandler {

    @Override
    protected String commandName() {
        return "drop";
    }
}
