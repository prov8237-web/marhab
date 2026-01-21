# Blueprint: Chat Backend على SmartFoxServer

> هذا التصميم مرتبط مباشرة بعقود الشات الموجودة في الكلاينت (انظر ChatController/AvatarModel).

## 1) Handlers المطلوبة (Java Extension)

### 1.1 Public Message Handler (غرفة عامة)
- **المدخل:** `PublicMessageRequest` من SmartFox (رسالة عامة من الغرفة).
- **مصدر العقد من الكلاينت:** `ChatController.send` (PublicMessageRequest مع `ts`).
- **المسؤوليات:**
  - التحقق من الطول (>=2 و<=100).
  - تطبيق فلتر تكرار الأحرف (نمط 8 تكرارات متتالية).
  - فحص Mute/Ban/Permission قبل البث.
  - إن لم يسمح بالإرسال، إرسال `publicMessageLimitExceeded` كـ ExtensionResponse برسالة واضحة.
- **استراتيجية البث:** غرفة `currentRoom` عبر مسار رسائل SmartFox العامة.

### 1.2 Whisper Handler
- **المدخل:** ExtensionRequest command = `whisper`.
- **مصدر العقد من الكلاينت:** `ChatController.send` مع `requestData("whisper")`.
- **Payload المطلوب:** `message`, `receiver`.
- **المسؤوليات:**
  - التحقق من الطول (>=2 و<=100).
  - التحقق من الإذن (`WHISPER` role) وإرجاع `errorCode=INSUFFICIENT_ROLE` عند الفشل.
  - التحقق من قائمة الحظر (block list) على السيرفر.
  - إيجاد المستخدم الهدف (receiver) وإرجاع `errorCode=USER_NOT_FOUND` عند عدم وجوده.
- **استراتيجية البث:**
  - رد `whisper` إلى المرسل والمستلم فقط.
  - رد `whispernotify` لباقي مستخدمي الغرفة لإظهار إشعار همس بدون محتوى.

### 1.3 publicMessageLimitExceeded Handler
- **المدخل:** Trigger داخلي من نظام الـRate Limit أو سياسات القيود.
- **مصدر العقد من الكلاينت:** `AvatarModel.listenExtension("publicMessageLimitExceeded")`.
- **Payload المطلوب:** `message`, `type`.
- **استراتيجية البث:** إرسال كرسالة خاصة للمستخدم فقط.

## 2) قواعد التحقق (Validation Rules)
- الطول: 2..100 حرف.
- فلتر التكرار المفرط للحروف (8 مرات متتالية) مماثل لمنطق الكلاينت.
- احترام قائمة الحظر (block list) على السيرفر.
- صلاحية `WHISPER` على الأقل للهمس.

## 3) Anti-Spam & Rate Limiting
- عداد رسائل لكل مستخدم داخل نافذة زمنية (مثال: 5 رسائل/5 ثوانٍ).
- عند تجاوز الحد: إرسال `publicMessageLimitExceeded` مع `type` ورسالة موجهة.

## 4) Moderation Hooks
- Mute/Ban hooks قبل الإرسال.
- فلتر كلمات مسيئة (Words Filter) على مستوى السيرفر.
- تسجيل الرسائل المخالفة للمتابعة (log).

## 5) استراتيجية البث (Broadcast Strategy)
- الرسائل العامة: `PublicMessageRequest` ضمن الغرفة.
- الهمس: إرسال `whisper` للمرسل/المستلم + `whispernotify` للغرفة.
- قيود الإرسال: `publicMessageLimitExceeded` للمرسل فقط.

## 6) مخرجات متوقعة من السيرفر (مطابقة لعقود الكلاينت)
- `publicMessage` (S->C) عبر SmartFox Event.
- `whisper` (S->C) عبر Extension Response.
- `whispernotify` (S->C) عبر Extension Response.
- `publicMessageLimitExceeded` (S->C) عبر Extension Response.
