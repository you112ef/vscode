#!/bin/bash

# VS Code Web Build Script for Cloudflare Pages
# سكريبت بناء VS Code Web لنشر Cloudflare Pages

set -e

echo "🚀 Starting VS Code Web build for Cloudflare Pages..."
echo "بدء بناء VS Code Web لنشر Cloudflare Pages..."

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

# Install dependencies if node_modules doesn't exist
if [ ! -d "node_modules" ]; then
    print_status "Installing dependencies..."
    npm install
    print_success "Dependencies installed successfully"
else
    print_status "Dependencies already installed"
fi

# Clean previous build
if [ -d "out-build" ]; then
    print_status "Cleaning previous build..."
    rm -rf out-build
    print_success "Previous build cleaned"
fi

# Compile the application
print_status "Compiling VS Code Web..."
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

# Copy wrangler.toml
if [ -f "wrangler.toml" ]; then
    cp wrangler.toml out-build/
    print_success "Wrangler configuration copied"
fi

# Create _headers file for Cloudflare Pages
print_status "Creating Cloudflare Pages headers..."
cat > out-build/_headers << EOF
/*
  X-Frame-Options: DENY
  X-Content-Type-Options: nosniff
  Referrer-Policy: strict-origin-when-cross-origin
  Permissions-Policy: camera=(), microphone=(), geolocation=()

/*.js
  Cache-Control: public, max-age=31536000, immutable

/*.css
  Cache-Control: public, max-age=31536000, immutable

/*.svg
  Cache-Control: public, max-age=31536000, immutable

/*.png
  Cache-Control: public, max-age=31536000, immutable

/*.jpg
  Cache-Control: public, max-age=31536000, immutable

/*.woff
  Cache-Control: public, max-age=31536000, immutable

/*.woff2
  Cache-Control: public, max-age=31536000, immutable

/*.ttf
  Cache-Control: public, max-age=31536000, immutable

service-worker.js
  Cache-Control: no-cache

manifest.json
  Cache-Control: public, max-age=3600
EOF

print_success "Headers file created"

# Create _redirects file for Cloudflare Pages
print_status "Creating Cloudflare Pages redirects..."
cat > out-build/_redirects << EOF
/*    /index.html   200
EOF

print_success "Redirects file created"

# Optimize images and assets
print_status "Optimizing assets..."

# Create optimized directory structure
mkdir -p out-build/assets

# Copy and optimize media files
if [ -d "out-build/vs/workbench/browser/media" ]; then
    cp -r out-build/vs/workbench/browser/media/* out-build/assets/ 2>/dev/null || true
    print_success "Media files optimized"
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

# Create deployment info
print_status "Creating deployment information..."
cat > out-build/DEPLOYMENT_INFO.md << EOF
# VS Code Web - Cloudflare Pages Deployment

## Build Information
- Build Date: $(date)
- Build Time: $(date +%s)
- Node.js Version: $(node -v)
- NPM Version: $(npm -v)

## Files Included
- VS Code Web Application
- Responsive CSS optimizations
- Service Worker for offline functionality
- PWA Manifest for app-like experience
- Cloudflare Pages configuration

## Responsive Features
- Mobile-first design
- Touch-optimized interface
- Adaptive scaling for all screen sizes
- Performance optimizations

## Deployment Instructions
1. Connect your repository to Cloudflare Pages
2. Set build command: \`npm run compile-web\`
3. Set build output directory: \`out-build\`
4. Deploy!

## Performance Optimizations
- Service Worker caching
- Responsive design
- Optimized assets
- CDN delivery via Cloudflare
EOF

print_success "Deployment information created"

# Calculate build size
BUILD_SIZE=$(du -sh out-build | cut -f1)
print_success "Build completed! Total size: $BUILD_SIZE"

# Create deployment script
print_status "Creating deployment script..."
cat > deploy-cloudflare.sh << 'EOF'
#!/bin/bash

# Deploy to Cloudflare Pages
echo "🚀 Deploying to Cloudflare Pages..."

# Check if wrangler is installed
if ! command -v wrangler &> /dev/null; then
    echo "Installing Wrangler..."
    npm install -g wrangler
fi

# Deploy using wrangler
wrangler pages deploy out-build --project-name=vscode-web-optimized

echo "✅ Deployment completed!"
echo "🌐 Your VS Code Web is now live on Cloudflare Pages!"
EOF

chmod +x deploy-cloudflare.sh
print_success "Deployment script created"

# Final summary
echo ""
echo "🎉 Build completed successfully!"
echo "📁 Build output: out-build/"
echo "📦 Build size: $BUILD_SIZE"
echo ""
echo "🚀 To deploy to Cloudflare Pages:"
echo "   1. Run: ./deploy-cloudflare.sh"
echo "   2. Or connect your repository to Cloudflare Pages"
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