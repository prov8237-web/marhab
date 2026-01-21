# وحدة الشات (Chat Backend Module) على SmartFoxServer 2X

## الهدف
تنفيذ شات عام للغرف + همس اختياري ضمن Java Extension، بدون الاعتماد على بروتوكولات أو أسماء أوامر خاصة بطرف ثالث.

## المكونات

### 1) DTOs
- `ChatMessage`: يمثل رسالة واحدة.
- `ChatMessageType`: نوع الرسالة (PUBLIC | WHISPER).

### 2) Service
- `ChatService`
  - `validateMessage(message)`
  - `checkPermissions(user, room)` (placeholder)
  - `rateLimit(userId)` (افتراضي: 5 رسائل/3 ثوانٍ)
  - `buildChatMessage(...)`

### 3) Store
- `InMemoryChatStore`
  - يحتفظ بآخر 50 رسالة لكل غرفة (قابل للتعديل عبر `ChatConfig`).

### 4) Handlers
- `chat.public.send` → `PublicChatHandler`
  - يستقبل `message` ويعيد `chat.public.message` للغرفة.
- `chat.whisper.send` → `WhisperChatHandler` (اختياري)
  - يستقبل `message` و`receiverId` ويعيد `chat.whisper.message` للمرسل والمستقبل.

## الإعدادات (ChatConfig)
- `maxLength`: الحد الأقصى لطول الرسالة (افتراضي 100).
- `rateLimitCount`: عدد الرسائل داخل النافذة الزمنية (افتراضي 5).
- `rateLimitWindowMs`: نافذة الزمن بالمللي ثانية (افتراضي 3000).
- `roomHistoryLimit`: عدد الرسائل المخزنة لكل غرفة (افتراضي 50).

## أمثلة طلبات/ردود (عامّة)

### طلب إرسال رسالة عامة
**Request Command:** `chat.public.send`
```json
{
  "message": "Hello world"
}
```

**Server Broadcast:** `chat.public.message`
```json
{
  "id": "<uuid>",
  "roomId": "street01",
  "senderId": "UserA",
  "message": "Hello world",
  "messageType": "PUBLIC",
  "sentAt": 1710000000000
}
```

### طلب إرسال همس (اختياري)
**Request Command:** `chat.whisper.send`
```json
{
  "message": "Hello privately",
  "receiverId": "UserB"
}
```

**Server Response:** `chat.whisper.message`
```json
{
  "id": "<uuid>",
  "roomId": "street01",
  "senderId": "UserA",
  "receiverId": "UserB",
  "message": "Hello privately",
  "messageType": "WHISPER",
  "sentAt": 1710000000000
}
```

### ردود أخطاء
- `chat.public.error`
- `chat.whisper.error`

## التسجيل (Logging)
يتم تسجيل كل إرسال بصيغة منظمة تتضمن:
- userId, roomId, messageId, type, ts, result.

## أماكن الملفات
- `/Backend/src5/ChatMessage.java`
- `/Backend/src5/ChatMessageType.java`
- `/Backend/src5/ChatConfig.java`
- `/Backend/src5/ChatService.java`
- `/Backend/src5/InMemoryChatStore.java`
- `/Backend/src5/ChatServices.java`
- `/Backend/src5/PublicChatHandler.java`
- `/Backend/src5/WhisperChatHandler.java`
