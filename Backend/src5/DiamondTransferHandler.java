package src5;

import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.data.*;
import java.util.*;

public class DiamondTransferHandler extends OsBaseHandler {
    
    private Map<String, Integer> diamondBalances = new HashMap<>();
    private Map<String, List<TransferRequest>> pendingTransfers = new HashMap<>();
    
    @Override
    public void handleClientRequest(User user, ISFSObject params) {
        String userName = user.getName();
        
        // تهيئة رصيد لو أول مرة
        diamondBalances.putIfAbsent(userName, 9999);
        
        String command = getRequestId();
        
        if (command == null) {
            trace("❌ ERROR: No requestId set!");
            return;
        }
        
        if ("diamondtransferrequest".equals(command)) {
            handleTransferRequest(user, params);
        } else if ("diamondtransferresponse".equals(command)) {
            handleTransferResponse(user, params);
        } else {
            trace("[DIAMOND] ⚠️ Unknown command: " + command);
        }
    }
    
    private void handleTransferRequest(User sender, ISFSObject params) {
        String targetAvatarID = params.getUtfString("avatarID");
        int quantity = params.getInt("quantity");
        String senderName = sender.getName();
        
        trace("[DIAMOND_TRANSFER] " + senderName + " → " + targetAvatarID + " : " + quantity);
        
        // التحقق من الرصيد
        int senderBalance = diamondBalances.getOrDefault(senderName, 0);
        if (senderBalance < quantity) {
            SFSObject errorRes = new SFSObject();
            errorRes.putUtfString("errorCode", "INSUFFICIENT_BALANCE");
            reply(sender, errorRes);
            return;
        }
        
        // إنشاء طلب نقل
        TransferRequest request = new TransferRequest();
        request.transferID = "TR" + System.currentTimeMillis();
        request.senderID = senderName;
        request.senderName = senderName;
        request.receiverID = targetAvatarID;
        request.quantity = quantity;
        request.timestamp = System.currentTimeMillis();
        request.status = "PENDING";
        
        // حفظ الطلب المعلق
        List<TransferRequest> targetPending = pendingTransfers.getOrDefault(targetAvatarID, new ArrayList<>());
        targetPending.add(request);
        pendingTransfers.put(targetAvatarID, targetPending);
        
        // خصم المبلغ من الرصيد (معلق)
        diamondBalances.put(senderName, senderBalance - quantity);
        
        trace("[DIAMOND_TRANSFER] ✅ Request created: " + request.transferID);
        
        // رد للمرسل
        SFSObject res = new SFSObject();
        res.putUtfString("transferID", request.transferID);
        res.putBool("success", true);
        reply(sender, res);
    }
    
    private void handleTransferResponse(User responder, ISFSObject params) {
        String transferID = params.getUtfString("diamondTransferID");
        String response = params.getUtfString("response");
        String responderName = responder.getName();
        
        trace("[DIAMOND_RESPONSE] " + responderName + " response: " + response + " for: " + transferID);
        
        // البحث عن الطلب
        TransferRequest request = findTransferRequest(transferID, responderName);
        if (request == null) {
            SFSObject errorRes = new SFSObject();
            errorRes.putUtfString("errorCode", "TRANSFER_NOT_FOUND");
            reply(responder, errorRes);
            return;
        }
        
        if ("ACCEPTED".equals(response)) {
            // إضافة الرصيد للمستلم
            int receiverBalance = diamondBalances.getOrDefault(responderName, 0);
            diamondBalances.put(responderName, receiverBalance + request.quantity);
            
            trace("[DIAMOND_RESPONSE] ✅ Transfer accepted");
            
        } else if ("REJECTED".equals(response)) {
            // إعادة الرصيد للمرسل
            int senderBalance = diamondBalances.getOrDefault(request.senderID, 0);
            diamondBalances.put(request.senderID, senderBalance + request.quantity);
            
            trace("[DIAMOND_RESPONSE] ❌ Transfer rejected");
        }
        
        // حذف الطلب من القائمة المعلقة
        removePendingTransfer(transferID, responderName);
        
        SFSObject res = new SFSObject();
        res.putBool("success", true);
        reply(responder, res);
    }
    
    private TransferRequest findTransferRequest(String transferID, String receiverID) {
        List<TransferRequest> pending = pendingTransfers.get(receiverID);
        if (pending != null) {
            for (TransferRequest req : pending) {
                if (req.transferID.equals(transferID) && req.receiverID.equals(receiverID)) {
                    return req;
                }
            }
        }
        return null;
    }
    
    private void removePendingTransfer(String transferID, String receiverID) {
        List<TransferRequest> pending = pendingTransfers.get(receiverID);
        if (pending != null) {
            Iterator<TransferRequest> iterator = pending.iterator();
            while (iterator.hasNext()) {
                TransferRequest req = iterator.next();
                if (req.transferID.equals(transferID)) {
                    iterator.remove();
                    break;
                }
            }
        }
    }
    
    class TransferRequest {
        String transferID;
        String senderID;
        String senderName;
        String receiverID;
        int quantity;
        long timestamp;
        String status;
    }
}