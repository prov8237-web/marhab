# اختبارات Smoke لوحدة الشات (P0)

## 1) إرسال رسالة عامة بنجاح
- **الخطوات:**
  1. الاتصال بالـZone والدخول لغرفة.
  2. إرسال `chat.public.send` مع `message` صالح.
- **المتوقع:**
  - بث `chat.public.message` لكل مستخدمي الغرفة.
  - سجل منظم يحتوي userId/roomId/messageId/type/ts/result.

## 2) منع رسالة فارغة
- **الخطوات:**
  1. إرسال `chat.public.send` مع `message` فارغ أو مسافات فقط.
- **المتوقع:**
  - رد `chat.public.error` مع `errorCode=EMPTY_MESSAGE`.

## 3) Rate Limit
- **الخطوات:**
  1. إرسال 6 رسائل خلال 3 ثوانٍ.
- **المتوقع:**
  - الرسالة السادسة تُرفض.
  - رد `chat.public.error` مع `errorCode=RATE_LIMIT`.

## 4) همس (اختياري)
- **الخطوات:**
  1. إرسال `chat.whisper.send` مع `receiverId` موجود.
- **المتوقع:**
  - رد `chat.whisper.message` للمرسل والمستقبل فقط.

## 5) همس لمستخدم غير موجود
- **الخطوات:**
  1. إرسال `chat.whisper.send` مع `receiverId` غير موجود.
- **المتوقع:**
  - رد `chat.whisper.error` مع `errorCode=USER_NOT_FOUND`.
