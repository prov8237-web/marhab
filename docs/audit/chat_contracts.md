# عقود الشات (Chat Contracts) المستخرجة من الكلاينت

> كل بند أدناه مبني على مسارات ملفات فعلية داخل الكلاينت المفكك.

## 1) publicMessage (S→C)
- **المصدر:** `Client/snl.779.swf/scripts/com/oyunstudyosu/chat/ChatController.as` → `ChatController.onPublicMessage`.
- **الآلية:** `SFSEvent` من SmartFox مع `params.sender` و`params.message`.
- **الـPayload:**
  - `sender`: كائن `User` (من `event.params.sender`).
  - `message`: `String` (من `event.params.message`).
- **النطاق:** بث غرفة (Room) لأن الحدث من رسائل الغرفة العامة.
- **ملاحظات سلوكية:** الرسالة تُمرّر إلى `processMessage` ثم `incomingMessage` مع فلاتر حظر المستخدم والحد الأقصى للطول (100).  

## 2) publicMessage (C→S)
- **المصدر:** `Client/snl.779.swf/scripts/com/oyunstudyosu/chat/ChatController.as` → `ChatController.send`.
- **الآلية:** `PublicMessageRequest` من SmartFox.
- **الـPayload:**
  - `message`: `String` (النص المرسل).
  - `ts`: `Long` عبر `SyncTimer.timestamp` داخل `SFSObject` إضافي.
- **النطاق:** بث غرفة عبر `currentRoom`.
- **قيود قبل الإرسال:** طول الرسالة ≥ 2، مع منع بعض الأنماط من الإدخال والتكرار الشديد في النص.

## 3) whisper (C→S)
- **المصدر:** `Client/snl.779.swf/scripts/com/oyunstudyosu/chat/ChatController.as` → `ChatController.send`.
- **الآلية:** `ExtensionRequest` عبر `serviceModel.requestData`.
- **الـPayload:**
  - `message`: `String`.
  - `receiver`: `String` (من `chatModel.whisperId`).
- **النطاق:** خاص (Private) عبر امتداد السيرفر.

## 4) whisper (S→C)
- **المصدر:** `Client/snl.779.swf/scripts/com/oyunstudyosu/chat/ChatController.as` → `ChatController.whisperToUser`.
- **الآلية:** `listenExtension("whisper")`.
- **الـPayload:**
  - `sender`: `String`.
  - `receiver`: `String`.
  - `message`: `String`.
  - `errorCode`: `String?` (اختياري؛ العميل يعالج الأخطاء باستثناء `INSUFFICIENT_ROLE`).
- **النطاق:** خاص، ويُعرض فقط إذا كان المستخدم هو المرسل أو المستقبل.

## 5) whispernotify (S→C)
- **المصدر:** `Client/snl.779.swf/scripts/com/oyunstudyosu/chat/ChatController.as` → `ChatController.whisperToAll`.
- **الآلية:** `listenExtension("whispernotify")`.
- **الـPayload:**
  - `sender`: `String`.
  - `receiver`: `String`.
  - `errorCode`: `String?`.
- **النطاق:** غرفة/عام (لإشعار باقي المستخدمين بحدوث همس بدون عرض محتوى الرسالة).

## 6) publicMessageLimitExceeded (S→C)
- **المصدر:** `Client/snl.779.swf/scripts/com/oyunstudyosu/avatar/AvatarModel.as` → `AvatarModel.publicMessageLimitExceeded`.
- **الآلية:** `listenExtension("publicMessageLimitExceeded")`.
- **الـPayload:**
  - `message`: `String`.
  - `type`: `String` (تُستخدم لفتح لوحات مثل `EmailPanel` أو `ProvisionPanel`).
- **النطاق:** خاص (Private) للعميل فقط.

## ملاحظات أخطاء (كما يفهمها الكلاينت)
- `whisper` قد يرد بـ `errorCode`؛ العميل يعرض Tooltip إلا إذا كان `INSUFFICIENT_ROLE`.
- `publicMessageLimitExceeded` يمثل سلوك Rate Limit/قيود إرسال رسائل عامة.

## ملفات الشات الأساسية داخل الكلاينت
- `Client/snl.779.swf/scripts/com/oyunstudyosu/chat/ChatController.as`
- `Client/snl.779.swf/scripts/com/oyunstudyosu/chat/ChatModel.as`
- `Client/snl.779.swf/scripts/com/oyunstudyosu/chat/ChatVO.as`
- `Client/snl.779.swf/scripts/com/oyunstudyosu/chat/IChatModel.as`
- `Client/snl.779.swf/scripts/com/oyunstudyosu/chat/SpeechBalloon.as`
- `Client/snl.779.swf/scripts/com/oyunstudyosu/chat/ChatColorTemplate.as`

## ملفات خارجية تستدعي عقود الشات
- `Client/snl.779.swf/scripts/com/oyunstudyosu/avatar/AvatarModel.as` (publicMessageLimitExceeded)
