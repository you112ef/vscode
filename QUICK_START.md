# 🚀 بدء سريع - VS Code Mobile APK

## طريقة سريعة (مستحسنة)

```bash
# 1. استنساخ المشروع
git clone https://github.com/YOUR_USERNAME/vscode-mobile-android.git
cd vscode-mobile-android

# 2. بناء APK بأمر واحد
chmod +x build-apk.sh
./build-apk.sh
```

## طريقة يدوية (للمتقدمين)

```bash
# 1. تثبيت المتطلبات
npm install
npm install -g @capacitor/cli @ionic/cli

# 2. بناء VS Code
npm run compile

# 3. إعداد مشروع المحمول
mkdir -p mobile-build
cp mobile-package.json mobile-build/package.json
cp capacitor.config.ts mobile-build/

# 4. نسخ ملفات البناء
mkdir -p mobile-build/out
cp -r out/* mobile-build/out/
cp src/vs/workbench/browser/media/mobile-android.css mobile-build/out/

# 5. إعداد Capacitor
cd mobile-build
npm install
npx cap add android
npx cap sync android

# 6. بناء APK
cd android
chmod +x gradlew
./gradlew assembleDebug
```

## تثبيت APK

```bash
# العثور على APK
find . -name "*.apk" -type f

# النسخ إلى مجلد التوزيع
mkdir -p apk-output
cp mobile-build/android/app/build/outputs/apk/debug/app-debug.apk apk-output/vscode-mobile.apk
```

## GitHub Actions (تلقائي)

فقط ادفع الكود إلى GitHub وسيتم بناء APK تلقائياً:

```bash
git add .
git commit -m "Add VS Code Mobile Android"
git push origin main
```

ثم حمل APK من GitHub Actions Artifacts.

---

**متطلبات:**
- Node.js 18+
- Java JDK 17+
- Android SDK (اختياري للبناء المحلي)

**الدعم:** افتح issue في GitHub للحصول على المساعدة.