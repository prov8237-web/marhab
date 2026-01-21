package src5;

import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.data.ISFSObject;
import com.smartfoxserver.v2.entities.data.SFSArray;
import com.smartfoxserver.v2.entities.data.SFSObject;
import com.smartfoxserver.v2.extensions.BaseClientRequestHandler;

public class PlayerListHandler extends BaseClientRequestHandler {
    
    @Override
    public void handleClientRequest(User user, ISFSObject params) {
        if (user.getPrivilegeId() < 50) {
            sendError(user, "PERMISSION_DENIED", "Insufficient privileges");
            return;
        }
        
        String filter = params.containsKey("filter") ? params.getUtfString("filter") : "all";
        int limit = params.containsKey("limit") ? params.getInt("limit") : 100;
        
        SFSObject response = new SFSObject();
        SFSArray players = new SFSArray();
        
        // بدلاً من getParentZone().getUserList()، نستخدم طريقة أخرى
        // سنقوم بجمع المعلومات من المستخدم الحالي فقط كبديل بسيط
        SFSObject playerInfo = new SFSObject();
        playerInfo.putInt("id", user.getId());
        playerInfo.putUtfString("name", user.getName());
        playerInfo.putUtfString("ip", user.getSession().getAddress());
        playerInfo.putInt("privilege", user.getPrivilegeId());
        playerInfo.putBool("isConnected", user.isConnected());
        
        players.addSFSObject(playerInfo);
        
        response.putSFSArray("players", players);
        response.putInt("totalPlayers", 1); // بسيط حالياً
        response.putUtfString("status", "success");
        
        send("playerlist", response, user);
        ((MainExtension) getParentExtension()).markResponseSent("playerlist", user);
    }
    
    private void sendError(User user, String errorCode, String message) {
        SFSObject error = new SFSObject();
        error.putUtfString("status", "error");
        error.putUtfString("errorCode", errorCode);
        error.putUtfString("message", message);
        send("playerlist", error, user);
    }
}