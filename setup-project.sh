#!/bin/bash

# 🚀 VS Code Mobile Android Project Setup Script
# سكريبت إعداد سريع للمشروع

set -e

# الألوان
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

# دوال العرض
print_header() {
    echo -e "\n${PURPLE}================================${NC}"
    echo -e "${PURPLE}🚀 $1${NC}"
    echo -e "${PURPLE}================================${NC}\n"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_step() {
    echo -e "\n${CYAN}📋 الخطوة $1: $2${NC}"
}

# المتغيرات
PROJECT_NAME="vscode-mobile-android"
GITHUB_USERNAME=""
PROJECT_DIR=""

# بداية السكريبت
print_header "إعداد مشروع VS Code Mobile Android"

echo -e "${CYAN}هذا السكريبت سيساعدك في:${NC}"
echo "1. إعداد ملفات المشروع"
echo "2. تحديث إعدادات GitHub"
echo "3. تحضير المشروع للرفع"
echo "4. إنشاء commit جاهز للدفع"
echo ""

# الحصول على معلومات المستخدم
print_step "1" "إدخال معلومات المستخدم"

read -p "أدخل اسم المستخدم في GitHub: " GITHUB_USERNAME
if [ -z "$GITHUB_USERNAME" ]; then
    print_error "اسم المستخدم مطلوب!"
    exit 1
fi

read -p "أدخل مسار مجلد المشروع [اتركه فارغاً للمجلد الحالي]: " PROJECT_DIR
if [ -z "$PROJECT_DIR" ]; then
    PROJECT_DIR="."
fi

print_success "تم: username=$GITHUB_USERNAME, directory=$PROJECT_DIR"

# التحقق من وجود الملفات
print_step "2" "التحقق من ملفات المشروع"

REQUIRED_FILES=(
    "capacitor.config.ts"
    "mobile-package.json"
    "build-apk.sh"
    ".github/workflows/build-android-apk.yml"
    "src/vs/workbench/browser/media/mobile-android.css"
)

cd "$PROJECT_DIR"

for file in "${REQUIRED_FILES[@]}"; do
    if [ -f "$file" ]; then
        print_success "موجود: $file"
    else
        print_warning "غير موجود: $file"
    fi
done

# تحديث أسماء المستخدمين
print_step "3" "تحديث إعدادات GitHub"

FILES_TO_UPDATE=(
    "README-APK-BUILD.md"
    ".github/workflows/build-android-apk.yml"
    "DEPLOYMENT_GUIDE.md"
    "PROJECT_SUMMARY.md"
    "CREATE_GITHUB_REPO.md"
)

for file in "${FILES_TO_UPDATE[@]}"; do
    if [ -f "$file" ]; then
        sed -i.bak "s/YOUR_USERNAME/$GITHUB_USERNAME/g" "$file"
        rm -f "$file.bak" 2>/dev/null || true
        print_success "محدث: $file"
    fi
done

# إعداد الصلاحيات
print_step "4" "إعداد الصلاحيات"

if [ -f "build-apk.sh" ]; then
    chmod +x build-apk.sh
    print_success "صلاحيات build-apk.sh محدثة"
fi

# إعداد README الرئيسي
print_step "5" "إعداد README الرئيسي"

if [ -f "README-APK-BUILD.md" ]; then
    cp README-APK-BUILD.md README.md
    print_success "README.md تم إنشاؤه من README-APK-BUILD.md"
fi

# إنشاء .gitignore إذا لم يكن موجوداً
print_step "6" "التحقق من .gitignore"

if [ ! -f ".gitignore" ]; then
    cat > .gitignore << 'EOF'
# VS Code Mobile Android - GitIgnore

# Node modules
node_modules/
npm-debug.log*
yarn-debug.log*
yarn-error.log*

# Build outputs
out/
dist/
build/
mobile-build/
apk-output/

# Android
*.apk
*.ap_
*.dex
*.class
local.properties
.gradle/
captures/

# Capacitor
.capacitor/

# Temporary files
*.tmp
*.temp
*.log
.cache/

# OS generated files
.DS_Store
Thumbs.db

# IDE
.vscode/
.idea/
*.iml

# Keep important files
!README*.md
!LICENSE*
!.github/
!src/vs/workbench/browser/media/mobile-android.css
EOF
    print_success "ملف .gitignore تم إنشاؤه"
else
    print_info "ملف .gitignore موجود مسبقاً"
fi

# إنشاء ملف معلومات البناء
print_step "7" "إنشاء ملف معلومات البناء"

cat > BUILD_INFO.json << EOF
{
  "project": "VS Code Mobile Android",
  "version": "1.0.0",
  "description": "VS Code Mobile for Android - محرر الأكواد المتقدم للهواتف الذكية",
  "repository": "https://github.com/$GITHUB_USERNAME/$PROJECT_NAME",
  "author": "$GITHUB_USERNAME",
  "created": "$(date -I)",
  "features": [
    "Mobile-optimized VS Code interface",
    "Touch-friendly controls (40×40px minimum)",
    "Arabic language support with RTL",
    "Dark mode by default",
    "Responsive design for all screen sizes",
    "Automatic APK building with GitHub Actions"
  ],
  "requirements": {
    "android": "7.0+ (API level 24)",
    "ram": "2GB minimum",
    "storage": "100MB free space",
    "architecture": "ARM64 or x86_64"
  },
  "buildInfo": {
    "nodejs": "18+",
    "capacitor": "5.5.1",
    "targetSdk": 34,
    "minSdk": 24
  }
}
EOF

print_success "ملف BUILD_INFO.json تم إنشاؤه"

# التحقق من Git
print_step "8" "إعداد Git"

if [ ! -d ".git" ]; then
    git init
    print_success "مستودع Git تم إنشاؤه"
else
    print_info "مستودع Git موجود مسبقاً"
fi

# إضافة remote إذا لم يكن موجوداً
if ! git remote get-url origin >/dev/null 2>&1; then
    git remote add origin "https://github.com/$GITHUB_USERNAME/$PROJECT_NAME.git"
    print_success "تم إضافة GitHub remote"
else
    print_info "GitHub remote موجود مسبقاً"
fi

# إنشاء commit جاهز
print_step "9" "إعداد Commit"

git add .

COMMIT_MESSAGE="🚀 VS Code Mobile Android - Initial Setup

✨ Features Added:
- Mobile-optimized VS Code interface with 70% scaling
- Touch-friendly controls (40×40px minimum touch areas)
- Arabic language support with full RTL compatibility
- Dark mode as default for battery saving
- Responsive design adapting to all screen sizes
- GitHub Actions for automatic APK building

📱 Mobile Optimizations:
- Icon size: 18-20px for clarity
- Font size: 13px for readability
- Button padding: 6px vertical, 8px horizontal
- Element spacing: 4-6px between buttons, 8px in lists
- Sidebar width: 20vw with responsive limits
- Modal dimensions: 90vw × 80vh with rounded corners

🎨 UI Improvements:
- CSS transform scaling for mobile devices
- Viewport units (vw/vh) for responsiveness
- Smooth scrolling and touch interactions
- Improved focus indicators for accessibility
- RTL layout support for Arabic interface

🛠️ Build System:
- Capacitor 5.5.1 for Android conversion
- GitHub Actions workflow for CI/CD
- Automated APK generation on push/PR/releases
- Debug and release build configurations
- Comprehensive error handling and logging

📚 Documentation:
- Complete setup guide (README-APK-BUILD.md)
- Quick start instructions (QUICK_START.md)
- GitHub deployment guide (DEPLOYMENT_GUIDE.md)
- Project overview (PROJECT_SUMMARY.md)
- Build troubleshooting guides

🌍 Localization:
- Arabic translations for all UI elements
- RTL-compatible layout and navigation
- Bilingual documentation (Arabic/English)
- Cultural adaptations for Arab developers

⚡ Performance:
- Optimized bundle size and loading times
- Memory usage optimization for mobile devices
- Efficient touch event handling
- Battery usage optimization

🔧 Technical Stack:
- TypeScript/JavaScript for core functionality
- Capacitor for native Android integration
- CSS3 for responsive mobile design
- GitHub Actions for automated building
- Gradle for Android APK compilation

Ready for GitHub deployment and APK generation!"

if git diff --cached --quiet; then
    print_warning "لا توجد تغييرات للcommit"
else
    git commit -m "$COMMIT_MESSAGE"
    print_success "تم إنشاء commit جاهز للدفع"
fi

# إنشاء ملف تعليمات سريعة
print_step "10" "إنشاء ملف التعليمات السريعة"

cat > NEXT_STEPS.md << EOF
# 🚀 الخطوات التالية

## ✅ تم الانتهاء من الإعداد

تم إعداد مشروع VS Code Mobile Android بنجاح!

## 📋 ما تم إنجازه:

- ✅ تحديث جميع الملفات باسم المستخدم: \`$GITHUB_USERNAME\`
- ✅ إعداد صلاحيات الملفات
- ✅ إنشاء README.md الرئيسي
- ✅ إنشاء .gitignore
- ✅ إعداد Git repository
- ✅ إضافة GitHub remote
- ✅ إنشاء commit جاهز للدفع

## 🚀 الخطوات التالية:

### 1. إنشاء مستودع GitHub:
\`\`\`bash
# اذهب إلى GitHub.com وأنشئ مستودع جديد باسم:
# vscode-mobile-android
\`\`\`

### 2. دفع المشروع إلى GitHub:
\`\`\`bash
git push -u origin main
\`\`\`

### 3. مراقبة بناء APK:
\`\`\`bash
# اذهب إلى:
https://github.com/$GITHUB_USERNAME/$PROJECT_NAME/actions
\`\`\`

### 4. تحميل APK:
\`\`\`bash
# من GitHub Actions Artifacts أو:
https://github.com/$GITHUB_USERNAME/$PROJECT_NAME/releases
\`\`\`

### 5. إنشاء أول Release:
\`\`\`bash
git tag v1.0.0
git push origin v1.0.0
\`\`\`

## 🔗 روابط مفيدة:

- **المستودع**: https://github.com/$GITHUB_USERNAME/$PROJECT_NAME
- **Actions**: https://github.com/$GITHUB_USERNAME/$PROJECT_NAME/actions
- **Releases**: https://github.com/$GITHUB_USERNAME/$PROJECT_NAME/releases

## 📚 مراجع إضافية:

- \`CREATE_GITHUB_REPO.md\` - دليل إنشاء المستودع
- \`QUICK_START.md\` - بدء سريع
- \`DEPLOYMENT_GUIDE.md\` - دليل النشر التفصيلي

---

**مبروك! مشروعك جاهز للنشر! 🎉**
EOF

print_success "ملف NEXT_STEPS.md تم إنشاؤه"

# عرض الملخص النهائي
print_header "✅ تم الانتهاء بنجاح!"

echo -e "${GREEN}🎊 تم إعداد مشروع VS Code Mobile Android بنجاح!${NC}\n"

echo -e "${CYAN}📋 ملخص ما تم:${NC}"
echo -e "  ✅ تحديث اسم المستخدم في جميع الملفات"
echo -e "  ✅ إعداد الصلاحيات والملفات"
echo -e "  ✅ إنشاء README.md و .gitignore"
echo -e "  ✅ إعداد Git repository"
echo -e "  ✅ إنشاء commit جاهز للدفع"

echo -e "\n${YELLOW}🚀 الخطوات التالية:${NC}"
echo -e "  1. أنشئ مستودع GitHub باسم: ${PURPLE}$PROJECT_NAME${NC}"
echo -e "  2. شغّل: ${PURPLE}git push -u origin main${NC}"
echo -e "  3. راقب البناء في GitHub Actions"
echo -e "  4. حمّل APK من Artifacts"

echo -e "\n${CYAN}🔗 روابط مفيدة:${NC}"
echo -e "  GitHub: ${BLUE}https://github.com/$GITHUB_USERNAME/$PROJECT_NAME${NC}"
echo -e "  Actions: ${BLUE}https://github.com/$GITHUB_USERNAME/$PROJECT_NAME/actions${NC}"

echo -e "\n${GREEN}📚 راجع ملف NEXT_STEPS.md للتفاصيل الكاملة${NC}"

echo -e "\n${PURPLE}🎉 مبروك! مشروعك جاهز للعالم! 🌍${NC}\n"