package src5;

public class MatchmakingCancelHandler extends SimpleAckHandler {

    @Override
    protected String commandName() {
        return "matchmakingCancel";
    }
}
