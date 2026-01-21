package auth;

import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.data.ISFSObject;
import com.smartfoxserver.v2.entities.data.SFSObject;
import com.smartfoxserver.v2.extensions.BaseClientRequestHandler;

public class LoginHandler extends BaseClientRequestHandler {
    @Override
    public void handleClientRequest(User user, ISFSObject params) {
        String username = params.getUtfString("username");
        trace("Login request from: " + username);
        
        // إجابة بسيطة للاختبار
        ISFSObject response = SFSObject.newInstance();
        response.putUtfString("status", "success");
        response.putUtfString("message", "Welcome " + username);
        response.putInt("user_id", 1);
        
        send("login_response", response, user);
    }
}