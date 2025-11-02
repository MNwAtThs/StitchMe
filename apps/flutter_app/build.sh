#!/bin/bash

# StitchMe Flutter Web Build Script for Vercel

echo "🚀 Building StitchMe Flutter Web App..."

# Install Flutter if not available
if ! command -v flutter &> /dev/null; then
    echo "📦 Installing Flutter..."
    git clone https://github.com/flutter/flutter.git -b stable --depth 1 /opt/flutter
    export PATH="$PATH:/opt/flutter/bin"
fi

# Verify Flutter installation
flutter --version

# Enable web support
flutter config --enable-web

# Get dependencies
echo "📦 Getting Flutter dependencies..."
flutter pub get

# Build for web with optimizations
echo "🔨 Building Flutter web app..."
flutter build web --release --base-href /

echo "✅ Build completed successfully!"
