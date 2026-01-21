package src5;

import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.data.ISFSObject;
import com.smartfoxserver.v2.entities.data.SFSObject;
import com.smartfoxserver.v2.extensions.BaseClientRequestHandler;

public abstract class OsBaseHandler extends BaseClientRequestHandler {
    
    private String currentRequestId;
    
    // تخزين الـ requestId الحالي
    public void setRequestId(String requestId) {
        this.currentRequestId = requestId;
    }
    
    public String getRequestId() {
        return currentRequestId;
    }
    
    protected void reply(User user, ISFSObject response) {
        if (currentRequestId != null) {
            send(currentRequestId, response, user);
        } else {
            trace("[ERROR] No requestId set for reply!");
        }
    }
    
    protected void reply(User user, String command, ISFSObject response) {
        send(command, response, user);
    }
    
    protected void trace(String message) {
        getParentExtension().trace(message);
    }
}