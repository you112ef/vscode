#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check prerequisites
print_status "Checking prerequisites..."

if ! command_exists node; then
    print_error "Node.js is not installed. Please install Node.js 18 or later."
    exit 1
fi

if ! command_exists npm; then
    print_error "npm is not installed. Please install npm."
    exit 1
fi

# Check Node.js version
NODE_VERSION=$(node -v | cut -d'v' -f2 | cut -d'.' -f1)
if [ "$NODE_VERSION" -lt 18 ]; then
    print_error "Node.js version must be 18 or later. Current version: $(node -v)"
    exit 1
fi

print_success "Prerequisites check passed!"

# Step 1: Install VS Code dependencies
print_status "Installing VS Code dependencies..."
if ! npm ci; then
    print_error "Failed to install VS Code dependencies"
    exit 1
fi

# Step 2: Compile VS Code
print_status "Compiling VS Code..."
if ! npm run compile; then
    print_error "Failed to compile VS Code"
    exit 1
fi

# Step 3: Set up mobile build environment
print_status "Setting up mobile build environment..."
rm -rf mobile-build
mkdir -p mobile-build
cp mobile-package.json mobile-build/package.json
if [ -f "capacitor.config.ts" ]; then
    cp capacitor.config.ts mobile-build/
fi

# Step 4: Install mobile dependencies
print_status "Installing mobile dependencies..."
cd mobile-build
if ! npm install; then
    print_error "Failed to install mobile dependencies"
    exit 1
fi

# Install Ionic and Capacitor CLI globally
print_status "Installing Ionic and Capacitor CLI..."
if ! npm install -g @ionic/cli @capacitor/cli; then
    print_warning "Failed to install CLI tools globally, trying locally..."
    npm install @ionic/cli @capacitor/cli
fi

# Step 5: Prepare web assets
print_status "Preparing web assets..."
mkdir -p www
cd ..

# Copy VS Code build output
if [ -d "out" ]; then
    print_status "Copying VS Code build output..."
    cp -r out/* mobile-build/www/
else
    print_warning "No VS Code build output found, creating basic structure..."
fi

# Copy mobile CSS
if [ -f "src/vs/workbench/browser/media/mobile-android.css" ]; then
    cp src/vs/workbench/browser/media/mobile-android.css mobile-build/www/
fi

# Create mobile index.html
print_status "Creating mobile index.html..."
cat > mobile-build/www/index.html << 'EOF'
<!DOCTYPE html>
<html lang="ar" dir="rtl">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <title>VS Code Mobile</title>
    <link rel="stylesheet" href="mobile-android.css">
    <style>
        body { 
            margin: 0; 
            padding: 0; 
            background: #1e1e1e; 
            color: #d4d4d4; 
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
        }
        .app-container { 
            display: flex; 
            justify-content: center; 
            align-items: center; 
            height: 100vh; 
            flex-direction: column;
            text-align: center;
            padding: 20px;
        }
        .logo { font-size: 48px; margin-bottom: 20px; }
        .title { font-size: 24px; margin-bottom: 10px; }
        .subtitle { font-size: 16px; opacity: 0.8; }
        .loading { animation: pulse 2s infinite; }
        @keyframes pulse {
            0% { opacity: 1; }
            50% { opacity: 0.5; }
            100% { opacity: 1; }
        }
    </style>
</head>
<body>
    <div class="app-container">
        <div class="logo">📱</div>
        <div class="title">VS Code Mobile</div>
        <div class="subtitle loading">مرحباً بك في VS Code المحمول!</div>
    </div>
    <script type="module">
        import { Capacitor } from '@capacitor/core';
        import { StatusBar } from '@capacitor/status-bar';
        import { SplashScreen } from '@capacitor/splash-screen';
        
        document.addEventListener('DOMContentLoaded', async () => {
            if (Capacitor.isNativePlatform()) {
                try {
                    await StatusBar.setBackgroundColor({ color: '#1e1e1e' });
                    await StatusBar.setStyle({ style: 'DARK' });
                    await SplashScreen.hide();
                } catch (e) {
                    console.log('Capacitor plugins not available in web mode');
                }
            }
            
            setTimeout(() => {
                document.querySelector('.subtitle').textContent = 'VS Code Mobile جاهز للاستخدام!';
                document.querySelector('.loading').classList.remove('loading');
            }, 2000);
        });
    </script>
</body>
</html>
EOF

# Step 6: Initialize Capacitor
cd mobile-build
print_status "Initializing Capacitor project..."
if ! npx cap init "VS Code Mobile" "com.vscode.mobile.android" --web-dir=www; then
    print_error "Failed to initialize Capacitor project"
    exit 1
fi

# Step 7: Add Android platform
print_status "Adding Android platform..."
if ! npx cap add android; then
    print_error "Failed to add Android platform"
    exit 1
fi

# Step 8: Sync and copy assets
print_status "Syncing Capacitor assets..."
npx cap sync android
npx cap copy android

# Step 9: Configure Android app
print_status "Configuring Android app..."
cat > android/app/src/main/res/values/strings.xml << 'EOF'
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <string name="app_name">VS Code Mobile</string>
    <string name="title_activity_main">VS Code Mobile</string>
    <string name="package_name">com.vscode.mobile.android</string>
    <string name="custom_url_scheme">vscode-mobile</string>
</resources>
EOF

# Step 10: Build APK
print_status "Building Android APK..."
cd android
chmod +x gradlew

print_status "Building debug APK..."
if ./gradlew assembleDebug --stacktrace; then
    print_success "Debug APK built successfully!"
else
    print_error "Failed to build debug APK"
    exit 1
fi

print_status "Building release APK..."
if ./gradlew assembleRelease --stacktrace; then
    print_success "Release APK built successfully!"
else
    print_warning "Release APK build failed, but debug APK is available"
fi

# Step 11: Copy APKs to output directory
cd ../..
mkdir -p apk-output

print_status "Copying APK files..."

if [ -f "mobile-build/android/app/build/outputs/apk/release/app-release.apk" ]; then
    cp mobile-build/android/app/build/outputs/apk/release/app-release.apk apk-output/vscode-mobile-release.apk
    print_success "Release APK copied to apk-output/vscode-mobile-release.apk"
elif [ -f "mobile-build/android/app/build/outputs/apk/release/app-release-unsigned.apk" ]; then
    cp mobile-build/android/app/build/outputs/apk/release/app-release-unsigned.apk apk-output/vscode-mobile-release-unsigned.apk
    print_success "Unsigned release APK copied to apk-output/vscode-mobile-release-unsigned.apk"
fi

if [ -f "mobile-build/android/app/build/outputs/apk/debug/app-debug.apk" ]; then
    cp mobile-build/android/app/build/outputs/apk/debug/app-debug.apk apk-output/vscode-mobile-debug.apk
    print_success "Debug APK copied to apk-output/vscode-mobile-debug.apk"
fi

# Create build info
cat > apk-output/BUILD_INFO.md << EOF
# VS Code Mobile APK Build

**Build Date:** $(date)
**Build Script:** build-apk.sh
**Node Version:** $(node -v)
**npm Version:** $(npm -v)

## Available APKs:
$(ls -la apk-output/*.apk 2>/dev/null || echo "No APK files found")

## Installation Instructions:
1. Enable "Unknown sources" in Android Settings > Security
2. Download the APK file to your Android device
3. Open the APK file and install
4. Enjoy VS Code Mobile!

## APK Types:
- **debug.apk**: For development and testing, larger file size
- **release.apk**: Optimized for production, smaller file size (if available)
- **release-unsigned.apk**: Release build but not signed for store distribution

## Troubleshooting:
- If installation fails, make sure you have Android 7.0+ (API level 24)
- Ensure you have at least 100MB free space
- Try the debug APK if release APK doesn't work
EOF

print_success "📱 APK build completed!"
echo ""
print_status "Available APK files:"
ls -la apk-output/*.apk 2>/dev/null || print_warning "No APK files found in output directory"

echo ""
print_success "🎉 Build completed successfully!"
print_status "APK files are available in the 'apk-output' directory"
print_status "Check BUILD_INFO.md for detailed build information"