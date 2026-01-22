package src5;

public class RemoveAvatarRestrictionHandler extends SimpleAckHandler {

    @Override
    protected String commandName() {
        return "removeavatarrestriction";
    }
}
