package src5;

public class PrivateChatListHandler extends SimpleAckHandler {

    @Override
    protected String commandName() {
        return "privatechatlist";
    }
}
