#!/bin/bash

# VS Code Web Build Script for Cloudflare Pages (Simplified)
# سكريبت بناء VS Code Web لنشر Cloudflare Pages (مبسط)

set -e

echo "🚀 Starting VS Code Web build for Cloudflare Pages (Simplified)..."
echo "بدء بناء VS Code Web لنشر Cloudflare Pages (مبسط)..."

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

# Check if Node.js is installed
if ! command -v node &> /dev/null; then
    print_error "Node.js is not installed. Please install Node.js first."
    exit 1
fi

# Check Node.js version
NODE_VERSION=$(node -v | cut -d'v' -f2 | cut -d'.' -f1)
if [ "$NODE_VERSION" -lt 16 ]; then
    print_error "Node.js version 16 or higher is required. Current version: $(node -v)"
    exit 1
fi

print_success "Node.js version: $(node -v)"

# Clean previous build
if [ -d "out-build" ]; then
    print_status "Cleaning previous build..."
    rm -rf out-build
    print_success "Previous build cleaned"
fi

# Install only web dependencies (skip native modules)
print_status "Installing web dependencies (skipping native modules)..."
npm install --ignore-scripts --no-optional

# Set environment variables for web-only build
export VSCODE_WEB_ENABLE_EXTENSIONS=true
export VSCODE_WEB_ENABLE_FILE_SYSTEM=true
export VSCODE_WEB_ENABLE_WORKBENCH=true

# Compile only the web version
print_status "Compiling VS Code Web (web-only)..."
npm run compile-web

if [ $? -eq 0 ]; then
    print_success "VS Code Web compiled successfully"
else
    print_error "Compilation failed"
    exit 1
fi

# Copy additional files for Cloudflare Pages
print_status "Copying Cloudflare Pages specific files..."

# Copy service worker
if [ -f "service-worker.js" ]; then
    cp service-worker.js out-build/
    print_success "Service worker copied"
fi

# Copy manifest
if [ -f "manifest.json" ]; then
    cp manifest.json out-build/
    print_success "PWA manifest copied"
fi

# Copy index.html
if [ -f "index.html" ]; then
    cp index.html out-build/
    print_success "Index HTML copied"
fi

# Copy Cloudflare Pages configuration files
print_status "Copying Cloudflare Pages configuration files..."

# Copy _headers file
if [ -f "_headers" ]; then
    cp _headers out-build/
    print_success "_headers file copied"
fi

# Copy _redirects file
if [ -f "_redirects" ]; then
    cp _redirects out-build/
    print_success "_redirects file copied"
fi

# Create robots.txt
print_status "Creating robots.txt..."
cat > out-build/robots.txt << EOF
User-agent: *
Allow: /

Sitemap: https://your-domain.pages.dev/sitemap.xml
EOF

print_success "Robots.txt created"

# Create sitemap.xml
print_status "Creating sitemap.xml..."
cat > out-build/sitemap.xml << EOF
<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
  <url>
    <loc>https://your-domain.pages.dev/</loc>
    <lastmod>$(date -u +%Y-%m-%dT%H:%M:%SZ)</lastmod>
    <changefreq>daily</changefreq>
    <priority>1.0</priority>
  </url>
</urlset>
EOF

print_success "Sitemap created"

# Calculate build size
BUILD_SIZE=$(du -sh out-build | cut -f1)
print_success "Build completed! Total size: $BUILD_SIZE"

# Final summary
echo ""
echo "🎉 Build completed successfully!"
echo "📁 Build output: out-build/"
echo "📦 Build size: $BUILD_SIZE"
echo ""
echo "🚀 Ready for Cloudflare Pages deployment!"
echo ""
echo "📱 Features included:"
echo "   ✅ Responsive design for all devices"
echo "   ✅ Mobile optimizations"
echo "   ✅ Service Worker for offline support"
echo "   ✅ PWA manifest for app-like experience"
echo "   ✅ Cloudflare Pages optimizations"
echo "   ✅ Performance enhancements"
echo ""
print_success "VS Code Web is ready for Cloudflare Pages deployment!"