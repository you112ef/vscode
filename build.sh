#!/bin/bash

# Simple build script for Cloudflare Pages
# This script bypasses npm entirely and runs our standalone build

echo "🚀 Starting VS Code Web build for Cloudflare Pages..."

# Run our standalone build script directly
node build-standalone.js

# Check if build was successful
if [ $? -eq 0 ]; then
    echo "✅ Build completed successfully!"
    exit 0
else
    echo "❌ Build failed!"
    exit 1
fi