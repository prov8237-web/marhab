package src5;

import com.smartfoxserver.v2.core.ISFSEvent;
import com.smartfoxserver.v2.core.SFSEventParam;
import com.smartfoxserver.v2.entities.Room;
import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.data.ISFSObject;
import com.smartfoxserver.v2.entities.data.SFSObject;
import com.smartfoxserver.v2.extensions.IServerEventHandler;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

public class PublicChatHandler extends OsBaseHandler implements IServerEventHandler {
    public static final String COMMAND = "chat.public.send";
    public static final String RESPONSE_EVENT = "chat.public.message";
    public static final String LEGACY_COMMAND = "chat";

    @Override
    public void handleClientRequest(User user, com.smartfoxserver.v2.entities.data.ISFSObject params) {
        ChatService service = ChatServices.getService();
        Room room = user.getLastJoinedRoom();
        String rawMessage = params != null && params.containsKey("message")
            ? params.getUtfString("message")
            : "";
        ChatService.ChatResult result = service.processPublicMessage(user, room, rawMessage);
        if (!result.isSuccess()) {
            sendError(user, result.getRoomId(), result.getErrorCode(), result.getErrorMessage());
            return;
        }

        ChatMessage chatMessage = result.getMessage();
        if (room == null) {
            sendError(user, result.getRoomId(), "ROOM_NOT_FOUND", "Room is required for public chat");
            return;
        }

        SFSObject payload = service.buildNewPayload(chatMessage);
        Collection<User> recipientCollection = room != null ? room.getUserList() : getParentExtension().getParentZone().getUserList();
        List<User> recipients = new ArrayList<>(recipientCollection);
        send(RESPONSE_EVENT, payload, recipients);

        SFSObject legacyPayload = service.buildLegacyPublicPayload(user, chatMessage);
        getApi().sendPublicMessage(room, user, chatMessage.getMessage(), legacyPayload);

        if (service.getConfig().isLegacyEventsEnabled()) {
            send("publicMessage", legacyPayload, recipients);
        }

        traceLog(chatMessage, "OK");
    }

    @Override
    public void handleServerEvent(ISFSEvent event) {
        User sender = (User) event.getParameter(SFSEventParam.USER);
        Room room = (Room) event.getParameter(SFSEventParam.ROOM);
        String message = (String) event.getParameter(SFSEventParam.MESSAGE);
        ISFSObject data = (ISFSObject) event.getParameter(SFSEventParam.DATA);
        if (sender == null || room == null || message == null) {
            trace("[CHAT_BRIDGE] Missing event parameters for legacy bridge.");
            return;
        }

        trace("[CHAT_BRIDGE] publicMessage senderName=" + sender.getName()
            + " senderId=" + sender.getId()
            + " roomName=" + room.getName()
            + " roomId=" + room.getId()
            + " message=\"" + message + "\""
            + " vars={avatarName=" + getUserVar(sender, "avatarName")
            + ", chatBalloon=" + getUserVar(sender, "chatBalloon")
            + ", mood=" + getUserVar(sender, "mood")
            + ", statusMessage=" + getUserVar(sender, "statusMessage")
            + "}"
            + " params=" + (data != null ? data.toJson() : "{}"));

        SFSObject legacyPayload = new SFSObject();
        legacyPayload.putUtfString("sender", sender.getName());
        legacyPayload.putUtfString("message", message);
        legacyPayload.putUtfString("roomId", room.getName());
        legacyPayload.putInt("chatBalloon", getChatBalloonType(sender));
        legacyPayload.putLong("ts", extractTimestamp(data));

        Collection<User> recipients = room.getUserList();
        send(LEGACY_COMMAND, legacyPayload, new ArrayList<>(recipients));
        trace("[CHAT_BRIDGE] command=" + LEGACY_COMMAND + " sender=" + sender.getName() + " roomId=" + room.getName());
    }

    private void sendError(User user, String roomId, String code, String message) {
        SFSObject error = new SFSObject();
        error.putUtfString("errorCode", code);
        error.putUtfString("message", message);
        error.putUtfString("roomId", roomId);
        send("chat.public.error", error, user);
        trace("[CHAT_PUBLIC] result=ERROR userId=" + user.getName() + " roomId=" + roomId + " code=" + code);
    }

    private int getChatBalloonType(User user) {
        if (user != null && user.containsVariable("chatBalloon")) {
            return user.getVariable("chatBalloon").getIntValue();
        }
        return 1;
    }

    private String getUserVar(User user, String name) {
        if (user == null || !user.containsVariable(name) || user.getVariable(name) == null) {
            return "null";
        }
        if (user.getVariable(name).isNull()) {
            return "null";
        }
        return String.valueOf(user.getVariable(name).getValue());
    }

    private long extractTimestamp(ISFSObject data) {
        if (data != null && data.containsKey("ts")) {
            return data.getLong("ts");
        }
        return System.currentTimeMillis();
    }

    private void traceLog(ChatMessage message, String result) {
        trace("[CHAT_PUBLIC] result=" + result
            + " userId=" + message.getSenderId()
            + " roomId=" + message.getRoomId()
            + " messageId=" + message.getId()
            + " type=" + message.getMessageType()
            + " ts=" + message.getSentAt());
    }
}
