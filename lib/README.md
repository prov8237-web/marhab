# مكتبات SmartFoxServer المطلوبة للبناء

ضع مكتبات SmartFoxServer 2X (ملفات JAR الرسمية) داخل هذا المجلد قبل التشغيل.

## المطلوب
- انسخ جميع ملفات الـJAR اللازمة من تثبيت SmartFoxServer 2X لديك (عادةً داخل مجلد `lib/` الخاص بالتثبيت).
- الهدف أن يحتوي هذا المجلد على حِزم `com.smartfoxserver.v2.*` التي يعتمد عليها الـExtension.

## مثال مسار المصدر (على جهازك)
- `<SFS2X_HOME>/lib/*.jar`

بعد وضع الملفات هنا يمكنك تشغيل البناء عبر:
```
ant -f build.xml
```

## أوامر بديلة (Fallback) للبناء اليدوي
### Linux/macOS
```
javac -cp "lib/*" -d build/classes Backend/src5/*.java
jar cf dist/marhab-extension.jar -C build/classes .
```

### Windows
```
javac -cp "lib/*" -d build\\classes Backend\\src5\\*.java
jar cf dist\\marhab-extension.jar -C build\\classes .
```
