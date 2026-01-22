package src5;

import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.data.ISFSObject;
import com.smartfoxserver.v2.entities.data.SFSObject;

public abstract class SimpleAckHandler extends OsBaseHandler {

    protected abstract String commandName();

    protected ISFSObject buildResponse(User user, ISFSObject params) {
        SFSObject res = new SFSObject();
        res.putBool("success", true);
        res.putUtfString("command", commandName());
        return res;
    }

    @Override
    public void handleClientRequest(User user, ISFSObject params) {
        String cmd = commandName();
        trace("[" + cmd.toUpperCase() + "] " + user.getName() + " request");
        ISFSObject res = buildResponse(user, params);
        reply(user, cmd, res);
        trace("[" + cmd.toUpperCase() + "] ✅ Response sent");
    }
}
