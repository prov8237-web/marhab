package src5;

public class GatherItemCollectHandler extends SimpleAckHandler {

    @Override
    protected String commandName() {
        return "gatheritemcollect";
    }
}
