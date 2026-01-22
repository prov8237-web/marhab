package src5;

import com.smartfoxserver.v2.entities.Room;
import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.data.ISFSObject;
import com.smartfoxserver.v2.entities.data.SFSObject;

public class SpeechBroadcastHandler extends OsBaseHandler {
    public static final String COMMAND = "speech.broadcast";
    private static final int MAX_MESSAGE_LENGTH = 100;
    private static final int MIN_MESSAGE_LENGTH = 2;

    @Override
    public void handleClientRequest(User sender, ISFSObject params) {
        Room room = sender.getLastJoinedRoom();
        if (room == null) {
            room = getParentExtension().getParentRoom();
        }
        if (room == null) {
            sendError(sender, "ROOM_NOT_FOUND", "Room is required for speech broadcast");
            return;
        }

        String message = params != null && params.containsKey("message")
            ? params.getUtfString("message")
            : "";

        if (message.length() > MAX_MESSAGE_LENGTH) {
            message = message.substring(0, MAX_MESSAGE_LENGTH);
        }

        if (message.length() < MIN_MESSAGE_LENGTH || isSpamMessage(message)) {
            sendError(sender, "INVALID_MESSAGE", "Message is not allowed");
            return;
        }

        if (!canUserChat(sender)) {
            sendError(sender, "CHAT_DISABLED", "User is not allowed to chat");
            return;
        }

        SFSObject data = new SFSObject();
        data.putUtfString("source", COMMAND);
        getApi().sendPublicMessage(room, sender, message, data);

        trace("[SPEECH_BROADCAST] user=" + sender.getName() + " room=" + room.getName());
    }

    private boolean isSpamMessage(String message) {
        if (message.length() < MIN_MESSAGE_LENGTH) {
            return true;
        }

        char lastChar = ' ';
        int repeatCount = 1;

        for (int i = 0; i < message.length(); i++) {
            char currentChar = message.charAt(i);

            if (currentChar == lastChar) {
                repeatCount++;
                if (repeatCount >= 8) {
                    return true;
                }
            } else {
                repeatCount = 1;
                lastChar = currentChar;
            }
        }

        return false;
    }

    private boolean canUserChat(User user) {
        return true;
    }

    private void sendError(User user, String code, String message) {
        SFSObject error = new SFSObject();
        error.putUtfString("errorCode", code);
        error.putUtfString("message", message);
        send(COMMAND, error, user);
    }
}
