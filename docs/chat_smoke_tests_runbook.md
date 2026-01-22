# تشغيل واختبار الشات (Runbook)

## 1) تشغيل السيرفر والعميل
1. شغّل SmartFoxServer 2X مع Zone `marhab`.
2. تأكد من تحميل Extension `src5.MainExtension`.
3. شغّل العميل (SWF/EXE) واتصل بالسيرفر المحلي.

## 2) سيناريو Public Chat (System + Dual-Publish عند التفعيل)
**الخطوات:**
- أدخل غرفة عامة.
- أرسل رسالة عبر الشات العام.
- راقب سجل الـDebug أو أي Logger للعميل الذي يعرض أحداث SmartFox.

**المتوقع:**
- **System Event:** استقبال `SFSEvent type="publicMessage"` (هذا ما يعتمد عليه الـCAHPNL.9.swf).
- **الحدث الجديد:** `chat.public.message` (Extension event).
- **الحدث القديم (فقط إذا كانت `legacyEventsEnabled=true`):** `publicMessage` كـExtension event.
- تظهر الرسالة في واجهة العميل.

## 3) سيناريو Whisper (نشر مزدوج)
**الخطوات:**
- أرسل همسًا لمستخدم موجود.

**المتوقع (Dual-Publish):**
- الحدث الجديد: `chat.whisper.message`
- الحدث القديم: `whisper`
- إشعار للغرفة (لغير المرسل/المستقبل): `whispernotify`

## 4) سيناريو Rate Limit
**الخطوات:**
- أرسل 6 رسائل خلال 3 ثوانٍ من نفس المستخدم.

**المتوقع:**
- رفض الرسالة السادسة.
- رد بخطأ `RATE_LIMIT` عبر `chat.public.error` أو `chat.whisper.error` حسب نوع الرسالة.

## 5) سيناريو Word Filter
**الخطوات:**
- أرسل رسالة تحتوي كلمة موجودة في blacklist.

**المتوقع:**
- رفض الرسالة مع `BLACKLISTED`.

## 6) سيناريو Mute
**الخطوات:**
- ضع المستخدم في حالة mute على السيرفر.
- حاول الإرسال خلال فترة الكتم.

**المتوقع:**
- رفض الرسالة مع `MUTED`.
