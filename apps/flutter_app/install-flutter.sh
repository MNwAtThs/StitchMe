#!/bin/bash

# Install Flutter for Vercel deployment
echo "🚀 Installing Flutter..."

# Set Flutter version
FLUTTER_VERSION="3.35.7"
FLUTTER_CHANNEL="stable"

# Download and install Flutter
cd /tmp
git clone https://github.com/flutter/flutter.git -b $FLUTTER_CHANNEL --depth 1
export PATH="$PATH:/tmp/flutter/bin"

# Verify Flutter installation
flutter --version

# Configure Flutter for web
flutter config --enable-web --no-analytics

echo "✅ Flutter installation completed!"

# Return to project directory and run commands
cd $VERCEL_SOURCE_PATH || cd /vercel/path0

echo "📦 Getting Flutter dependencies..."
flutter pub get

echo "🔨 Building Flutter web app..."
flutter build web --release

echo "✅ Build completed successfully!"
