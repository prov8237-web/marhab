# تقرير توصيل أوامر الشات (Chat Wiring Report)

## 1) أوامر الشات المسجلة حالياً في MainExtension
**المصدر:** `Backend/src5/MainExtension.java`
- `chat.public.send` → `PublicChatHandler`
- `chat.whisper.send` → `WhisperChatHandler`
- `chatballoon` → `ChatBalloonHandler`
- `chatext` → `ChatExtensions`

> تم إزالة تسجيل الأوامر القديمة `chat` و`whisper` من الـExtension لضمان مسار واحد رسمي.

## 2) التعارضات المكتشفة
**قبل التعديل:**
- `chat` كان مرتبطًا بـ `ChatHandler` ويُرسل `publicMessage` مباشرة للغرفة.
- `chat.public.send` مرتبط بـ `PublicChatHandler` مع منطق خدمة جديد.
- `whisper` كان مرتبطًا بـ `WhisperHandler` ويُرسل `whisper`/`whispernotify`.
- `chat.whisper.send` مرتبط بـ `WhisperChatHandler` مع منطق خدمة جديد.

**النتيجة:** وجود مسارين مختلفين للشات العام والهمس. تم اعتماد المسار الجديد فقط.

## 3) مسار التنفيذ الرسمي (Single Source of Truth)
- **المسار الرسمي للشات العام:** `PublicChatHandler` + `ChatService` + `InMemoryChatStore`.
- **المسار الرسمي للهمس:** `WhisperChatHandler` + `ChatService`.

## 4) التوصيل النهائي للأوامر (Command → Handler)

### P0: Public Chat
- **Command:** `chat.public.send`
- **Handler:** `PublicChatHandler`
- **Params المطلوبة:**
  - `message` (String)
- **نوع البث المتوقع:** broadcast للغرفة عبر `chat.public.message`.
- **معايير قبول P0:**
  - رسالة غير فارغة بعد trim.
  - طول الرسالة <= الحد الأقصى من `ChatConfig`.
  - تطبيق Rate Limit (5 رسائل/3 ثوانٍ قابلة للتعديل).

### P1: Whisper (اختياري)
- **Command:** `chat.whisper.send`
- **Handler:** `WhisperChatHandler`
- **Params المطلوبة:**
  - `message` (String)
  - `receiverId` (String)
- **نوع البث المتوقع:** رد خاص للمرسل والمستقبل عبر `chat.whisper.message`.
- **معايير قبول P1:**
  - رسالة غير فارغة بعد trim.
  - مستقبل موجود.
  - تطبيق Rate Limit.

### أوامر مساندة للشات
- **Command:** `chatballoon`
  - **Handler:** `ChatBalloonHandler`
  - **بث:** رد خاص للمستخدم بـ `chatballoonlist`.
- **Command:** `chatext`
  - **Handler:** `ChatExtensions`
  - **بث:** ردود مثل `chatsettings`, `settingsupdated`, `reportresponse`, `blockresponse`, `chaterror`.

## 5) ملاحظة توافقية
- الأوامر القديمة `chat` و`whisper` لم تعد مسجلة في `MainExtension`.
- إذا احتجنا توافقًا مع عملاء قديمة، يجب إعادة تسجيلها وتمريرها عبر `ChatService` بدل منطق مستقل.
