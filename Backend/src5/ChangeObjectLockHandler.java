package src5;

public class ChangeObjectLockHandler extends SimpleAckHandler {

    @Override
    protected String commandName() {
        return "changeobjectlock";
    }
}
