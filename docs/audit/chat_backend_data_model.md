# نموذج بيانات الشات (Chat Data Model)

## 1) ChatMessage Entity
- **id**: UUID/Long (مولّد على السيرفر)
- **roomId**: String (مُعرّف الغرفة الحالية)
- **senderId**: String (اسم/معرّف المستخدم كما يظهر في SmartFox)
- **receiverId**: String? (يُملأ في حالة whisper فقط)
- **message**: String (محدودة بـ 100 حرف كما في الكلاينت)
- **messageType**: Enum (PUBLIC | WHISPER)
- **chatBalloon**: Int (من متغير المستخدم `chatBalloon` عند الحاجة لعرض البالون)
- **sentAt**: Long (timestamp؛ يتطابق مع `ts` في الكلاينت عند توفره)

## 2) استراتيجية التخزين
### خيار A: In-Memory فقط (بدون سجل دائم)
- تخزين آخر N رسائل لكل غرفة في الذاكرة.
- مناسب كبداية سريعة.

### خيار B: DB History (اختياري)
- **Table: chat_messages**
  - `id` (PK)
  - `room_id` (index)
  - `sender_id` (index)
  - `receiver_id` (nullable, index)
  - `message` (text)
  - `message_type` (enum)
  - `chat_balloon` (int)
  - `sent_at` (timestamp)
- **Indexes المقترحة:**
  - `(room_id, sent_at)` لعرض سجل الغرفة.
  - `(receiver_id, sent_at)` لسجل الهمس للمستخدم.

> هذا النموذج يظل اختياريًا، ويُفعل فقط إذا أردنا سجل رسائل حقيقي.
