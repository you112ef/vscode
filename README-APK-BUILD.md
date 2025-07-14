# 🚀 دليل بناء VS Code Mobile APK للأندرويد
# VS Code Mobile Android APK Build Guide

<div align="center">

![VS Code Mobile](https://img.shields.io/badge/VS%20Code-Mobile-blue?style=for-the-badge&logo=visual-studio-code)
![Android](https://img.shields.io/badge/Android-7.0+-green?style=for-the-badge&logo=android)
![License](https://img.shields.io/badge/License-MIT-yellow?style=for-the-badge)
![Build Status](https://img.shields.io/badge/Build-Automated-brightgreen?style=for-the-badge)

**محرر الأكواد المتقدم VS Code محسن خصيصاً لجوالات الأندرويد**

[🔗 تحميل APK](#-تحميل-apk) • [📖 التعليمات](#-التعليمات) • [🛠️ البناء المحلي](#️-البناء-المحلي) • [❓ الدعم](#-الدعم)

</div>

---

## 📱 نظرة عامة / Overview

هذا المشروع يحول **VS Code** إلى تطبيق أندرويد مُحسن للهواتف الذكية مع واجهة محسنة للمس وتصميم متجاوب.

This project converts **VS Code** into an Android application optimized for smartphones with touch-friendly interface and responsive design.

### ✨ المميزات / Features

| الميزة | الوصف |
|--------|--------|
| 📱 **واجهة محسنة للمس** | أزرار وأيقونات بحجم مناسب للمس (40×40px) |
| 🎨 **تصميم متجاوب** | يتكيف مع جميع أحجام الشاشات والاتجاهات |
| 🌙 **وضع داكن افتراضي** | يوفر الطاقة ويريح العين |
| ⚡ **أداء محسن** | بناء مُحسن لاستهلاك الذاكرة والمعالج |
| 🔄 **بناء تلقائي** | GitHub Actions يبني APK تلقائياً |
| 🌍 **دعم اللغة العربية** | واجهة تدعم RTL والنصوص العربية |

---

## 🔗 تحميل APK / Download APK

### الطريقة الأولى: من GitHub Releases
1. اذهب إلى صفحة [Releases](../../releases)
2. حمّل أحدث ملف `.apk`
3. ثبت التطبيق على جهازك

### الطريقة الثانية: بناء APK بنفسك
اتبع القسم [البناء المحلي](#️-البناء-المحلي) أدناه.

### الطريقة الثالثة: من GitHub Actions
1. اذهب إلى تبويب [Actions](../../actions)
2. اختر آخر build ناجح
3. حمّل APK من قسم "Artifacts"

---

## 📋 متطلبات النظام / System Requirements

### للتطبيق المُثبت:
- **Android**: 7.0+ (API level 24)
- **الذاكرة**: 2GB RAM أو أكثر
- **التخزين**: 100MB مساحة فارغة
- **المعالج**: ARM64 أو x86_64

### للبناء المحلي:
- **Node.js**: 18+ 
- **Java**: JDK 17
- **Android Studio**: أو Android SDK
- **Git**: لاستنساخ المشروع

---

## 🛠️ البناء المحلي / Local Build

### الخطوة 1: استنساخ المشروع
```bash
git clone https://github.com/YOUR_USERNAME/vscode-mobile-android.git
cd vscode-mobile-android
```

### الخطوة 2: تثبيت المتطلبات
```bash
# تثبيت Node.js dependencies
npm install

# تثبيت Capacitor CLI
npm install -g @capacitor/cli @ionic/cli
```

### الخطوة 3: بناء VS Code
```bash
# بناء VS Code الأساسي
npm run compile

# أو استخدم البناء المتوازي للسرعة
npm run watch
```

### الخطوة 4: إعداد Capacitor
```bash
# نسخ الإعدادات
cp mobile-package.json package-mobile.json
mkdir -p mobile-build
cp capacitor.config.ts mobile-build/
cp package-mobile.json mobile-build/package.json

# الانتقال لمجلد البناء المحمول
cd mobile-build

# تثبيت dependencies المحمولة
npm install

# إضافة منصة Android
npx cap add android
```

### الخطوة 5: نسخ ملفات VS Code
```bash
# العودة للمجلد الرئيسي
cd ..

# نسخ ملفات البناء
mkdir -p mobile-build/out
cp -r out/* mobile-build/out/
cp -r src/vs/workbench/browser/media/* mobile-build/out/
```

### الخطوة 6: مزامنة Capacitor
```bash
cd mobile-build
npx cap sync android
```

### الخطوة 7: بناء APK
```bash
# فتح Android Studio
npx cap open android

# أو البناء من سطر الأوامر
cd android
./gradlew assembleDebug

# للإصدار النهائي
./gradlew assembleRelease
```

### 📂 العثور على APK المُبني
```bash
mobile-build/android/app/build/outputs/apk/debug/app-debug.apk
# أو
mobile-build/android/app/build/outputs/apk/release/app-release.apk
```

---

## 🔄 البناء التلقائي / Automated Build

### إعداد GitHub Actions

المشروع يحتوي على GitHub Actions يبني APK تلقائياً عند:
- Push إلى الفروع الرئيسية
- إنشاء Pull Request
- إنشاء Tag جديد
- تشغيل يدوي (workflow_dispatch)

### تفعيل البناء التلقائي:

1. **رفع الكود إلى GitHub:**
```bash
git add .
git commit -m "Initial VS Code Mobile setup"
git push origin main
```

2. **مراقبة البناء:**
   - اذهب إلى تبويب "Actions" في مستودع GitHub
   - راقب تقدم البناء
   - حمّل APK من "Artifacts" عند الانتهاء

3. **إنشاء Release:**
```bash
# إنشاء tag للإصدار
git tag v1.0.0
git push origin v1.0.0
```

---

## 📱 تثبيت التطبيق / App Installation

### الخطوة 1: تمكين التثبيت من مصادر غير معروفة
1. اذهب إلى **الإعدادات** → **الأمان**
2. فعّل **"السماح بالتثبيت من مصادر غير معروفة"**
3. أو اختر **"تثبيت التطبيقات من مصادر أخرى"**

### الخطوة 2: تحميل وتثبيت APK
1. حمّل ملف APK على جهازك
2. افتح ملف APK من مدير الملفات
3. اتبع تعليمات التثبيت
4. اضغط **"تثبيت"**

### الخطوة 3: تشغيل التطبيق
1. ابحث عن **"VS Code Mobile"** في قائمة التطبيقات
2. اضغط على الأيقونة لتشغيل التطبيق
3. استمتع بـ VS Code على هاتفك! 🎉

---

## ⚙️ التخصيص / Customization

### تعديل الألوان والسمات:
```css
/* في ملف mobile-android.css */
.monaco-workbench {
    --custom-primary-color: #your-color;
    --custom-background-color: #your-background;
}
```

### تعديل حجم التحجيم:
```css
/* تغيير مقياس التحجيم من 70% إلى 80% */
.monaco-workbench {
    transform: scale(0.8);
}
```

### إضافة لغات جديدة:
```xml
<!-- في android/app/src/main/res/values/strings.xml -->
<string name="new_language_text">النص الجديد</string>
```

---

## 🐛 استكشاف الأخطاء / Troubleshooting

### مشاكل شائعة وحلولها:

#### ❌ خطأ: "Build failed"
```bash
# تنظيف وإعادة بناء
npm run clean
npm install
npm run compile
```

#### ❌ خطأ: "Android SDK not found"
```bash
# تثبيت Android SDK
npm install -g @android/sdk-tools
# أو استخدم Android Studio
```

#### ❌ خطأ: "Capacitor not initialized"
```bash
cd mobile-build
npx cap init "VS Code Mobile" "com.vscode.mobile.android" --web-dir=out
npx cap add android
```

#### ❌ خطأ: "Permission denied"
```bash
# إعطاء صلاحيات للملفات
chmod +x mobile-build/android/gradlew
```

#### ❌ APK لا يعمل على الجهاز
- تأكد من أن إصدار Android 7.0+
- تحقق من توفر مساحة كافية (100MB+)
- امسح cache التطبيق وأعد التثبيت

---

## 📊 معلومات البناء / Build Information

```json
{
  "appName": "VS Code Mobile",
  "packageName": "com.vscode.mobile.android",
  "version": "1.0.0",
  "minSdk": 24,
  "targetSdk": 34,
  "features": [
    "VS Code Web Interface",
    "Mobile Optimized UI", 
    "Dark Mode Support",
    "Touch Optimizations",
    "RTL Language Support",
    "File System Access"
  ]
}
```

---

## 🚀 المميزات المستقبلية / Future Features

- [ ] 📝 **محرر نصوص محلي** - تحرير ملفات بدون إنترنت
- [ ] 🔌 **دعم الإضافات** - تثبيت extensions
- [ ] 🐙 **تكامل Git** - عمليات Git مباشرة  
- [ ] 🖥️ **وضع سطح المكتب** - للأجهزة اللوحية
- [ ] 🌐 **مزامنة السحابة** - مزامنة الإعدادات والملفات
- [ ] 🎤 **التحكم الصوتي** - أوامر صوتية للبرمجة
- [ ] 🔔 **إشعارات ذكية** - تنبيهات البناء والأخطاء

---

## 🤝 المساهمة / Contributing

نرحب بمساهماتكم! إليك كيفية المساهمة:

### 1. Fork المشروع
```bash
# استنساخ fork الخاص بك
git clone https://github.com/YOUR_USERNAME/vscode-mobile-android.git
cd vscode-mobile-android
```

### 2. إنشاء فرع جديد
```bash
git checkout -b feature/amazing-feature
```

### 3. تطبيق التغييرات
```bash
git add .
git commit -m "Add amazing feature"
```

### 4. رفع التغييرات
```bash
git push origin feature/amazing-feature
```

### 5. إنشاء Pull Request
اذهب إلى GitHub وأنشئ Pull Request.

---

## 📄 الترخيص / License

هذا المشروع مرخص تحت **MIT License** - راجع ملف [LICENSE](LICENSE) للتفاصيل.

```
MIT License

Copyright (c) 2024 VS Code Mobile Team

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.
```

---

## 📞 الدعم / Support

### طرق الحصول على المساعدة:

- 🐛 **الإبلاغ عن مشاكل**: [Issues](../../issues)
- 💬 **النقاش والأسئلة**: [Discussions](../../discussions)  
- 📧 **الاتصال المباشر**: support@vscode-mobile.dev
- 📱 **Telegram**: [@vscode_mobile](https://t.me/vscode_mobile)

### قبل الإبلاغ عن مشكلة:
1. تأكد من قراءة هذا الدليل كاملاً
2. ابحث في Issues المفتوحة عن مشاكل مشابهة
3. تأكد من استخدام أحدث إصدار

### عند الإبلاغ عن مشكلة، أرفق:
- إصدار التطبيق ونوع الجهاز
- خطوات إعادة إنتاج المشكلة
- لقطات شاشة إن أمكن
- ملفات السجل (logs) إن وجدت

---

## 📈 الإحصائيات / Statistics

![GitHub Downloads](https://img.shields.io/github/downloads/YOUR_USERNAME/vscode-mobile-android/total?style=flat-square)
![GitHub Stars](https://img.shields.io/github/stars/YOUR_USERNAME/vscode-mobile-android?style=flat-square)
![GitHub Forks](https://img.shields.io/github/forks/YOUR_USERNAME/vscode-mobile-android?style=flat-square)
![GitHub Issues](https://img.shields.io/github/issues/YOUR_USERNAME/vscode-mobile-android?style=flat-square)

---

## 🙏 شكر خاص / Special Thanks

- **Microsoft**: لتطوير VS Code الرائع
- **Ionic Team**: لـ Capacitor المذهل  
- **Android Team**: لمنصة Android المفتوحة
- **المساهمون**: جميع من ساهم في هذا المشروع

---

<div align="center">

**صُنع بـ ❤️ للمطورين العرب**

**Made with ❤️ for Arab Developers**

[⬆️ العودة للأعلى](#-دليل-بناء-vs-code-mobile-apk-للأندرويد)

</div>