# Backlog: Chat Backend (SmartFoxServer)

> كل بند مرتبط بعقد محدد من الكلاينت، مع ذكر مسار الملف كدليل.

## P0

### 1) تنفيذ استقبال الرسائل العامة (PublicMessageRequest)
- **Scope:** استقبال الرسالة العامة وتطبيق التحقق ثم بثها للغرفة.
- **Client Evidence:** `Client/snl.779.swf/scripts/com/oyunstudyosu/chat/ChatController.as` → `send()` يستخدم `PublicMessageRequest` و`ts` ضمن `SFSObject`.
- **Backend Handler/Service:** `PublicMessageHandler` (SFS event handler) أو `ChatPublicHandler`.
- **Acceptance Criteria:**
  - يرفض الرسائل <2 أو >100 حرف.
  - يطبق فلتر التكرار المفرط (8 مرات متتالية).
  - يبث إلى الغرفة الحالية.
- **Priority:** P0
- **Size:** M

### 2) تنفيذ ExtensionRequest للهمس (whisper)
- **Scope:** استقبال `whisper` مع `message` و`receiver`، ثم ردود `whisper` و`whispernotify`.
- **Client Evidence:** `Client/snl.779.swf/scripts/com/oyunstudyosu/chat/ChatController.as` → `requestData("whisper")` + `listenExtension("whisper")` و`listenExtension("whispernotify")`.
- **Backend Handler/Service:** `WhisperHandler`.
- **Acceptance Criteria:**
  - يرد بـ `errorCode=INSUFFICIENT_ROLE` عند عدم الصلاحية.
  - يرد بـ `errorCode=USER_NOT_FOUND` عند عدم وجود المستقبل.
  - يرسل `whisper` للمرسل والمستلم و`whispernotify` للغرفة.
- **Priority:** P0
- **Size:** M

### 3) تنفيذ تنبيه Rate Limit (publicMessageLimitExceeded)
- **Scope:** إرسال رسالة تحذير عند تجاوز الحد.
- **Client Evidence:** `Client/snl.779.swf/scripts/com/oyunstudyosu/avatar/AvatarModel.as` → `listenExtension("publicMessageLimitExceeded")`.
- **Backend Handler/Service:** `ChatRateLimitNotifier`.
- **Acceptance Criteria:**
  - إرسال `publicMessageLimitExceeded` مع `message` و`type`.
- **Priority:** P0
- **Size:** S

## P1

### 4) دمج كلمات محظورة + فلترة محتوى
- **Scope:** فلتر كلمات مسيئة قبل البث.
- **Client Evidence:** لا يوجد منطق فلترة في الكلاينت؛ الاعتماد على السيرفر.
- **Backend Handler/Service:** `ChatModerationService`.
- **Acceptance Criteria:**
  - يمنع الرسائل التي تحتوي كلمات محظورة.
  - يسجل الحوادث.
- **Priority:** P1
- **Size:** M

### 5) دعم إعدادات المستخدم المتعلقة بالشات
- **Scope:** احترام إعدادات الاستقبال (مثل إخفاء الرسائل/الهمس).
- **Client Evidence:** `ChatController.incomingMessage()` يتحقق من `avatarModel.settings.incomingMessages` و`pero`.
- **Backend Handler/Service:** `ChatPreferencesService`.
- **Acceptance Criteria:**
  - عدم إرسال إشعارات لمن عطّل الاستقبال (إذا كان ممثلاً في السيرفر لاحقًا).
- **Priority:** P1
- **Size:** S

## P2

### 6) سجل الرسائل (Chat History)
- **Scope:** حفظ الرسائل وإرجاع سجل للمستخدم عند الطلب.
- **Client Evidence:** `ChatModel.add()` يرسل `ChatHistoryEvent("add_history")` داخليًا.
- **Backend Handler/Service:** `ChatHistoryService`.
- **Acceptance Criteria:**
  - حفظ آخر N رسائل لكل غرفة.
  - إمكانية الاسترجاع لاحقًا.
- **Priority:** P2
- **Size:** L
