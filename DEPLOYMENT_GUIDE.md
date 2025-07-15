# 📚 دليل النشر على GitHub
# GitHub Deployment Guide

## 🎯 الهدف

إنشاء مستودع GitHub يبني APK تلقائياً لتطبيق VS Code Mobile Android.

---

## 📋 خطوات النشر

### 1. إنشاء مستودع GitHub جديد

```bash
# إنشاء مستودع جديد على GitHub
# اسم المستودع المقترح: vscode-mobile-android
```

**الإعدادات المطلوبة:**
- ✅ Public Repository (لاستخدام GitHub Actions مجاناً)
- ✅ Add README file (سيتم استبداله)
- ✅ Add .gitignore (Node.js)
- ✅ Choose License (MIT)

### 2. استنساخ المستودع محلياً

```bash
git clone https://github.com/YOUR_USERNAME/vscode-mobile-android.git
cd vscode-mobile-android
```

### 3. إضافة ملفات المشروع

```bash
# نسخ جميع الملفات من مشروع VS Code الحالي
cp -r /path/to/vscode/* .

# أو إذا كنت في مجلد VS Code
cp capacitor.config.ts /path/to/vscode-mobile-android/
cp mobile-package.json /path/to/vscode-mobile-android/
cp build-apk.sh /path/to/vscode-mobile-android/
cp -r .github/ /path/to/vscode-mobile-android/
cp -r android/ /path/to/vscode-mobile-android/
cp README-APK-BUILD.md /path/to/vscode-mobile-android/
cp QUICK_START.md /path/to/vscode-mobile-android/
```

### 4. تحديث ملفات README

```bash
# نسخ README الجديد
cp README-APK-BUILD.md README.md

# تحديث الروابط في الملف ليشير لمستودعك
sed -i 's/YOUR_USERNAME/your-github-username/g' README.md
sed -i 's/YOUR_USERNAME/your-github-username/g' .github/workflows/build-android-apk.yml
```

### 5. إعداد GitHub Actions

الملف `.github/workflows/build-android-apk.yml` موجود بالفعل ولكن تأكد من:

```yaml
# التحقق من إعدادات workflow
name: Build Android APK
on:
  push:
    branches: [ main, master, develop ]
  pull_request:
    branches: [ main, master ]
  workflow_dispatch:  # للتشغيل اليدوي
```

### 6. رفع المشروع إلى GitHub

```bash
# إضافة جميع الملفات
git add .

# commit الأولي
git commit -m "🚀 Initial VS Code Mobile Android setup

- Add mobile-optimized VS Code interface
- Add Capacitor configuration for Android
- Add GitHub Actions for automatic APK building
- Add Arabic language support and RTL interface
- Add touch-optimized controls and responsive design
- Add comprehensive documentation and guides"

# رفع إلى GitHub
git push origin main
```

---

## 🔧 إعداد GitHub Actions

### تمكين GitHub Actions

1. اذهب إلى مستودعك على GitHub
2. تبويب **Actions**
3. اضغط **Enable GitHub Actions** إذا لم تكن مفعلة

### إعدادات المستودع المطلوبة

```bash
# في إعدادات المستودع (Settings):
```

**Actions permissions:**
- ✅ Allow all actions and reusable workflows

**Workflow permissions:**
- ✅ Read and write permissions
- ✅ Allow GitHub Actions to create and approve pull requests

### متغيرات البيئة (اختيارية)

إذا كنت تريد توقيع APK:

```bash
# في Settings > Secrets and variables > Actions
ANDROID_KEYSTORE_FILE=<base64-encoded-keystore>
ANDROID_KEYSTORE_PASSWORD=<password>
ANDROID_KEY_ALIAS=<alias>
ANDROID_KEY_PASSWORD=<key-password>
```

---

## 🏗️ اختبار البناء

### بناء تلقائي

```bash
# إنشاء commit جديد لتشغيل البناء
git commit --allow-empty -m "🧪 Test GitHub Actions build"
git push origin main
```

### مراقبة البناء

1. اذهب إلى تبويب **Actions**
2. اضغط على آخر workflow run
3. راقب تقدم البناء
4. حمّل APK من **Artifacts** عند انتهاء البناء

### تشغيل البناء يدوياً

1. تبويب **Actions**
2. اختر **Build Android APK**
3. اضغط **Run workflow**
4. اختر branch (main)
5. اضغط **Run workflow**

---

## 📱 إنشاء Release

### إنشاء tag للإصدار

```bash
# إنشاء tag v1.0.0
git tag v1.0.0 -m "🎉 VS Code Mobile v1.0.0

First stable release with:
- Mobile-optimized interface
- Touch-friendly controls
- Dark mode by default
- Arabic/RTL language support
- Responsive design for all screen sizes"

# رفع tag إلى GitHub
git push origin v1.0.0
```

### مميزات Release التلقائي

عند إنشاء tag، GitHub Actions سيقوم بـ:

- ✅ بناء APK تلقائياً
- ✅ إنشاء GitHub Release
- ✅ رفع APK إلى Release
- ✅ إنشاء release notes تلقائياً
- ✅ نشر معلومات الإصدار

---

## 🌐 مشاركة المشروع

### روابط مهمة للمشاركة

```markdown
## 🔗 روابط المشروع

- **المستودع**: https://github.com/YOUR_USERNAME/vscode-mobile-android
- **أحدث APK**: https://github.com/YOUR_USERNAME/vscode-mobile-android/releases/latest
- **Build Status**: https://github.com/YOUR_USERNAME/vscode-mobile-android/actions
- **Documentation**: https://github.com/YOUR_USERNAME/vscode-mobile-android/blob/main/README.md
```

### Badges للمشروع

أضف هذه في README.md:

```markdown
![Build Status](https://github.com/YOUR_USERNAME/vscode-mobile-android/workflows/Build%20Android%20APK/badge.svg)
![Release](https://img.shields.io/github/v/release/YOUR_USERNAME/vscode-mobile-android)
![Downloads](https://img.shields.io/github/downloads/YOUR_USERNAME/vscode-mobile-android/total)
![License](https://img.shields.io/github/license/YOUR_USERNAME/vscode-mobile-android)
```

---

## 🔄 تحديث المشروع

### إضافة مميزات جديدة

```bash
# إنشاء فرع جديد للميزة
git checkout -b feature/new-awesome-feature

# تطبيق التغييرات
# ... code changes ...

# commit التغييرات
git add .
git commit -m "✨ Add new awesome feature"

# رفع الفرع
git push origin feature/new-awesome-feature

# إنشاء Pull Request على GitHub
```

### تحديث الإصدار

```bash
# تحديث رقم الإصدار في mobile-package.json
sed -i 's/"version": "1.0.0"/"version": "1.1.0"/g' mobile-package.json

# تحديث في android/app/build.gradle
sed -i 's/versionName "1.0.0"/versionName "1.1.0"/g' android/app/build.gradle

# commit وإنشاء tag جديد
git add .
git commit -m "🔖 Bump version to 1.1.0"
git tag v1.1.0
git push origin main --tags
```

---

## 🛠️ استكشاف الأخطاء

### مشاكل شائعة في GitHub Actions

#### ❌ Build fails with "Node.js not found"
```yaml
# في .github/workflows/build-android-apk.yml
- name: Setup Node.js
  uses: actions/setup-node@v4
  with:
    node-version: '18'  # تأكد من الإصدار
```

#### ❌ Android SDK issues
```yaml
# تأكد من إعدادات Android SDK
- name: Setup Android SDK
  uses: android-actions/setup-android@v3
  with:
    api-level: 34
    build-tools: 34.0.0
```

#### ❌ Permission denied errors
```bash
# تأكد من صلاحيات الملفات
chmod +x build-apk.sh
chmod +x mobile-build/android/gradlew
```

### حلول سريعة

```bash
# إعادة تشغيل البناء الفاشل
git commit --allow-empty -m "🔄 Retry build"
git push origin main

# تنظيف cache GitHub Actions
# اذهب إلى Settings > Actions > General > Clear cache
```

---

## 📊 مراقبة الأداء

### معلومات مفيدة لمراقبتها

- **Build time**: متوسط وقت البناء
- **APK size**: حجم APK الناتج
- **Download count**: عدد تحميلات الإصدارات
- **Issues**: المشاكل المفتوحة والمغلقة
- **Stars/Forks**: اهتمام المجتمع

### تحسين الأداء

```yaml
# تحسين وقت البناء في GitHub Actions
- name: Cache Node modules
  uses: actions/cache@v3
  with:
    path: ~/.npm
    key: ${{ runner.os }}-node-${{ hashFiles('**/package-lock.json') }}
```

---

## 🎉 الخطوات النهائية

### قائمة التحقق النهائية

- [ ] المستودع منشور على GitHub
- [ ] GitHub Actions تعمل بنجاح
- [ ] APK يتم بناؤه تلقائياً
- [ ] Release الأول تم إنشاؤه
- [ ] README محدث بالروابط الصحيحة
- [ ] Documentation كامل ومفهوم
- [ ] Tests تعمل بنجاح
- [ ] APK يعمل على الأجهزة الحقيقية

### مشاركة المشروع

```bash
# إنشاء post للمشاركة
echo "🚀 تم إطلاق VS Code Mobile للأندرويد!

محرر الأكواد المتقدم VS Code متوفر الآن للهواتف الذكية مع:
✅ واجهة محسنة للمس
✅ دعم كامل للعربية والـ RTL  
✅ تصميم متجاوب
✅ وضع داكن افتراضي
✅ بناء تلقائي على GitHub

🔗 https://github.com/YOUR_USERNAME/vscode-mobile-android
📱 حمّل APK مباشرة من Releases

#VSCode #Android #Mobile #Programming #Arabic #تطوير"
```

---

**🎊 تهانينا! مشروعك جاهز للعالم!**