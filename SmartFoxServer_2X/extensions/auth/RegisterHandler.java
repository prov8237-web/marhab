package auth;

import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.data.ISFSObject;
import com.smartfoxserver.v2.entities.data.SFSObject;
import com.smartfoxserver.v2.extensions.BaseClientRequestHandler;

public class RegisterHandler extends BaseClientRequestHandler {
    @Override
    public void handleClientRequest(User user, ISFSObject params) {
        String username = params.getUtfString("username");
        trace("Register request for: " + username);
        
        ISFSObject response = SFSObject.newInstance();
        response.putUtfString("status", "success");
        response.putUtfString("message", "Account created for " + username);
        response.putInt("user_id", 2);
        
        send("register_response", response, user);
    }
}