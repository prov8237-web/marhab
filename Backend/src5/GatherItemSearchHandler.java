package src5;

public class GatherItemSearchHandler extends SimpleAckHandler {

    @Override
    protected String commandName() {
        return "gatheritemsearch";
    }
}
