package src5;

public class DebugCommandHandler extends SimpleAckHandler {

    @Override
    protected String commandName() {
        return "debugcommand";
    }
}
