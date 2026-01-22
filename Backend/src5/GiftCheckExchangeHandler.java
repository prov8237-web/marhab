package src5;

public class GiftCheckExchangeHandler extends SimpleAckHandler {

    @Override
    protected String commandName() {
        return "giftcheckexchange";
    }
}
