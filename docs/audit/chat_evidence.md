# Evidence Pack لعقود الشات

> جميع المقتطفات أدناه لا تتجاوز 15 سطر لكل مقتطف، ومرفقة بمسار الملف والكلاس والميثود وأرقام الأسطر (nl -ba).

## Contract: publicMessage (C→S)

### إرسال الرسالة + بناء الـpayload (ts)
- **Path:** `Client/snl.779.swf/scripts/com/oyunstudyosu/chat/ChatController.as`
- **Class:** `ChatController`
- **Method:** `send`
- **Lines:** 320-334
```text
   320      public function send(param1:String) : void
   321      {
   322         var _loc2_:ISFSObject = null;
   323         if(Sanalika.instance.chatModel.whisperMode)
   324         {
   325            Sanalika.instance.serviceModel.requestData("whisper",{
   326               "message":param1,
   327               "receiver":Sanalika.instance.chatModel.whisperId
   328            },null);
   329         }
   330         else
   331         {
   332            _loc2_ = new SFSObject();
   333            _loc2_.putLong("ts",SyncTimer.timestamp);
   334            Sanalika.instance.serviceModel.sfs.send(new PublicMessageRequest(param1,_loc2_,Sanalika.instance.roomModel.currentRoom));
```

## Contract: publicMessage (S→C)

### تسجيل الاستماع للحدث
- **Path:** `Client/snl.779.swf/scripts/com/oyunstudyosu/chat/ChatController.as`
- **Class:** `ChatController`
- **Method:** `ChatController()` (constructor)
- **Lines:** 51-56
```text
    51         Dispatcher.addEventListener("tf_focus_in",focusInToCurrentTextField);
    52         Dispatcher.addEventListener("tf_focus_out",focusOutFromCurrentTextField);
    53         Dispatcher.addEventListener("sendMessage",sendMessage);
    54         Sanalika.instance.serviceModel.sfs.addEventListener("publicMessage",onPublicMessage);
    55         Sanalika.instance.serviceModel.listenExtension("whisper",whisperToUser);
    56         Sanalika.instance.serviceModel.listenExtension("whispernotify",whisperToAll);
```

### معالج الاستقبال واستخراج الـpayload
- **Path:** `Client/snl.779.swf/scripts/com/oyunstudyosu/chat/ChatController.as`
- **Class:** `ChatController`
- **Method:** `onPublicMessage`
- **Lines:** 153-157
```text
   153      private function onPublicMessage(param1:SFSEvent) : void
   154      {
   155         var _loc3_:User = param1.params.sender;
   156         var _loc2_:String = String(param1.params.message);
   157         processMessage(_loc3_,_loc2_);
```

## Contract: whisper (C→S)

### إرسال الهمس + بناء الـpayload
- **Path:** `Client/snl.779.swf/scripts/com/oyunstudyosu/chat/ChatController.as`
- **Class:** `ChatController`
- **Method:** `send`
- **Lines:** 323-328
```text
   323         if(Sanalika.instance.chatModel.whisperMode)
   324         {
   325            Sanalika.instance.serviceModel.requestData("whisper",{
   326               "message":param1,
   327               "receiver":Sanalika.instance.chatModel.whisperId
   328            },null);
```

## Contract: whisper (S→C)

### تسجيل الاستماع للحدث
- **Path:** `Client/snl.779.swf/scripts/com/oyunstudyosu/chat/ChatController.as`
- **Class:** `ChatController`
- **Method:** `ChatController()` (constructor)
- **Lines:** 54-55
```text
    54         Sanalika.instance.serviceModel.sfs.addEventListener("publicMessage",onPublicMessage);
    55         Sanalika.instance.serviceModel.listenExtension("whisper",whisperToUser);
```

### معالج الاستقبال واستخراج الـpayload
- **Path:** `Client/snl.779.swf/scripts/com/oyunstudyosu/chat/ChatController.as`
- **Class:** `ChatController`
- **Method:** `whisperToUser`
- **Lines:** 108-120
```text
   108      private function whisperToUser(param1:Object) : void
   109      {
   110         var _loc8_:AlertVo = null;
   111         if(param1.errorCode != null && param1.errorCode != "INSUFFICIENT_ROLE")
   112         {
   113            (_loc8_ = new AlertVo()).alertType = "tooltip";
   114            _loc8_.description = Sanalika.instance.localizationModel.translate(param1.errorCode);
   115            Dispatcher.dispatchEvent(new AlertEvent(_loc8_));
   116            return;
   117         }
   118         var _loc3_:String = String(param1.message);
   119         var _loc2_:String = String(param1.sender);
   120         var _loc5_:String = String(param1.receiver);
```

## Contract: whispernotify (S→C)

### تسجيل الاستماع للحدث
- **Path:** `Client/snl.779.swf/scripts/com/oyunstudyosu/chat/ChatController.as`
- **Class:** `ChatController`
- **Method:** `ChatController()` (constructor)
- **Lines:** 55-56
```text
    55         Sanalika.instance.serviceModel.listenExtension("whisper",whisperToUser);
    56         Sanalika.instance.serviceModel.listenExtension("whispernotify",whisperToAll);
```

### معالج الاستقبال واستخراج الـpayload
- **Path:** `Client/snl.779.swf/scripts/com/oyunstudyosu/chat/ChatController.as`
- **Class:** `ChatController`
- **Method:** `whisperToAll`
- **Lines:** 70-77
```text
    70      private function whisperToAll(param1:Object) : void
    71      {
    72         if(param1.errorCode != null)
    73         {
    74            return;
    75         }
    76         var _loc4_:String = String(param1.sender);
    77         var _loc6_:String = String(param1.receiver);
```

## Contract: publicMessageLimitExceeded (S→C)

### تسجيل الاستماع للحدث
- **Path:** `Client/snl.779.swf/scripts/com/oyunstudyosu/avatar/AvatarModel.as`
- **Class:** `AvatarModel`
- **Method:** `AvatarModel()` (constructor)
- **Lines:** 137-140
```text
   137         Sanalika.instance.serviceModel.listenExtension("securitycaptcha",controlSecurityCaptcha);
   138         Sanalika.instance.serviceModel.listenExtension("securitykey",controlSecurityKey);
   139         Sanalika.instance.serviceModel.listenExtension("userFlatEntered",userFlatEntered);
   140         Sanalika.instance.serviceModel.listenExtension("publicMessageLimitExceeded",publicMessageLimitExceeded);
```

### معالج الاستقبال (استخدام message/type)
- **Path:** `Client/snl.779.swf/scripts/com/oyunstudyosu/avatar/AvatarModel.as`
- **Class:** `AvatarModel`
- **Method:** `publicMessageLimitExceeded`
- **Lines:** 211-218
```text
   211      private function publicMessageLimitExceeded(param1:Object) : void
   212      {
   213         var _loc3_:PanelVO = null;
   214         _loc3_ = null;
   215         var _loc2_:AlertVo = null;
   216         if(param1.message)
   217         {
   218            if(param1.type == "emailActivation")
```
