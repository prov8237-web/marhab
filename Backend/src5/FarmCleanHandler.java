package src5;

public class FarmCleanHandler extends SimpleAckHandler {

    @Override
    protected String commandName() {
        return "farmclean";
    }
}
