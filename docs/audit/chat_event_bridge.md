# جسر أحداث الشات (Old ↔ New)

## 1) أحداث الكلاينت الحالية
- **الشات العام:** يستقبل `publicMessage` عبر SmartFox Event.
- **الهمس:** يستقبل `whisper` و`whispernotify` عبر Extension Events.

## 2) الأحداث الجديدة في السيرفر
- **public:** `chat.public.message`
- **whisper:** `chat.whisper.message`

## 3) نشر مزدوج (Dual-Publish)
### شات عام
- **جديد:** `chat.public.message`
- **قديم:** `publicMessage`

### همس
- **جديد:** `chat.whisper.message`
- **قديم:** `whisper` (للمرسل/المستقبل)
- **قديم:** `whispernotify` (لباقي مستخدمي الغرفة)

## 4) Mapping الـPayload

### public → chat.public.message (جديد)
```json
{
  "id": "<uuid>",
  "roomId": "<room>",
  "senderId": "<user>",
  "message": "<text>",
  "messageType": "PUBLIC",
  "sentAt": 1710000000000
}
```

### public → publicMessage (قديم)
```json
{
  "sender": "<user>",
  "message": "<text>",
  "chatBalloon": 1,
  "ts": 1710000000000
}
```

### whisper → chat.whisper.message (جديد)
```json
{
  "id": "<uuid>",
  "roomId": "<room>",
  "senderId": "<user>",
  "receiverId": "<user>",
  "message": "<text>",
  "messageType": "WHISPER",
  "sentAt": 1710000000000
}
```

### whisper → whisper (قديم)
```json
{
  "sender": "<user>",
  "receiver": "<user>",
  "message": "<text>",
  "chatBalloon": 11
}
```

### whispernotify (قديم)
```json
{
  "sender": "<user>",
  "receiver": "<user>"
}
```

## 5) إيقاف القديم تدريجيًا (Feature Flag)
- استخدم `ChatConfig.legacyEventsEnabled` لتعطيل نشر الأحداث القديمة لاحقًا.
- الخطة المقترحة:
  1. تحديث الكلاينت ليتبنى الأحداث الجديدة.
  2. تشغيل مزدوج لمدة إصدارين.
  3. تعطيل `legacyEventsEnabled` ثم إزالة النشر القديم.
