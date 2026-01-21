package src5;

import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.data.*;
import com.smartfoxserver.v2.entities.variables.*;
import java.util.*;

public class Street01RoomVariables {
    
    public static void ensureStreet01RoomVariables(com.smartfoxserver.v2.entities.Room room) {
        List<RoomVariable> vars = new ArrayList<>();
        
        // Room metadata
        if (!room.containsVariable("roomKey")) {
            vars.add(new SFSRoomVariable("roomKey", "street01"));
        }
        if (!room.containsVariable("width")) {
            vars.add(new SFSRoomVariable("width", 850));
        }
        if (!room.containsVariable("height")) {
            vars.add(new SFSRoomVariable("height", 500));
        }
        if (!room.containsVariable("type")) {
            vars.add(new SFSRoomVariable("type", "OUTDOOR"));
        }
        if (!room.containsVariable("roomTitle")) {
            vars.add(new SFSRoomVariable("roomTitle", "الشارع الرئيسي"));
        }
        if (!room.containsVariable("theme")) {
            vars.add(new SFSRoomVariable("theme", "snow"));
        }
        if (!room.containsVariable("doorCount")) {
            vars.add(new SFSRoomVariable("doorCount", 1));
        }
        
        // Door variables
        if (!room.containsVariable("door0_id")) {
            vars.add(new SFSRoomVariable("door0_id", "d5"));
        }
        if (!room.containsVariable("door0_x")) {
            vars.add(new SFSRoomVariable("door0_x", 275));
        }
        if (!room.containsVariable("door0_y")) {
            vars.add(new SFSRoomVariable("door0_y", 614));
        }
        if (!room.containsVariable("door0_targetRoom")) {
            vars.add(new SFSRoomVariable("door0_targetRoom", "street01"));
        }
        
        // Chat balloon (مهم لظهور بلونة التحدث)
        if (!room.containsVariable("chatBalloon")) {
            vars.add(new SFSRoomVariable("chatBalloon", 1)); // Default balloon
        }
        
        // Room properties
        if (!room.containsVariable("allowWalk")) {
            vars.add(new SFSRoomVariable("allowWalk", true));
        }
        if (!room.containsVariable("allowChat")) {
            vars.add(new SFSRoomVariable("allowChat", true));
        }
        if (!room.containsVariable("minimap")) {
            vars.add(new SFSRoomVariable("minimap", "street01"));
        }
        
        if (!vars.isEmpty()) {
            // يجب أن تكون هنا وظيفة setRoomVariables
            // هذا يعتمد على كيف تحصل على API في مكانك
            System.out.println("[ROOMVARS] Ensuring room variables for street01: " + vars.size());
        }
    }
}