package src5;

public class FarmGatherHandler extends SimpleAckHandler {

    @Override
    protected String commandName() {
        return "farmgather";
    }
}
