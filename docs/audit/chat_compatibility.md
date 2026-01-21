# توافق الشات مع أوامر الكلاينت الحالية

## 1) الأوامر التي يستخدمها الكلاينت فعليًا
- **الهمس:** الكلاينت يرسل `whisper` عبر `requestData("whisper", {message, receiver})`.
- **الشات العام:** الكلاينت يستخدم `PublicMessageRequest` (طلب نظامي في SmartFox) وليس `chat.public.send`.

## 2) طبقة التوافق المضافة
- **chat (قديم) → ChatService/ChatMessageType.PUBLIC**
  - يتم تسجيل الأمر `chat` كطبقة توافق فقط، ويعيد بث الرسالة عبر `chat.public.message`.
- **whisper (قديم) → ChatService/ChatMessageType.WHISPER**
  - يتم تسجيل الأمر `whisper` كطبقة توافق فقط، ويعيد الرسالة عبر `chat.whisper.message`.

## 3) الخرائط (Mapping)

### أوامر قديمة → مسار جديد
- `chat` → `ChatService` → broadcast `chat.public.message`
- `whisper` → `ChatService` → send `chat.whisper.message`

### أحداث الاستقبال
- **المسار الجديد:**
  - public: `chat.public.message`
  - whisper: `chat.whisper.message`

> ملاحظة: الكلاينت الحالي يستقبل `publicMessage` و`whisper`/`whispernotify`، لذلك قد يتطلب تحديثًا على الكلاينت لاحقًا ليتوافق مع المسار الجديد بالكامل.

## 4) مخاطر التوافق
- استمرار دعم الأوامر القديمة قد يُبقي مسارين للبث (رسائل عامة عبر النظام وامتداد جديد).
- اختلاف أسماء الأحداث المستلمة قد يسبب ازدواجية أو عدم ظهور الرسائل في بعض الإصدارات.

## 5) خطة الإيقاف لاحقًا
1. تحديث الكلاينت ليستخدم `chat.public.send` و`chat.whisper.send` ويستقبل `chat.public.message` و`chat.whisper.message`.
2. مراقبة الحركة لمدة إصدارين للتأكد من عدم وجود عملاء قديمة.
3. إزالة تسجيل `chat` و`whisper` من `MainExtension` بعد التأكد من التوافق.
