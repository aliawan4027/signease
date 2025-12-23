#!/bin/bash

echo "🚀 Building Flutter app for Vercel deployment..."

# Install Flutter if not available
if ! command -v flutter &> /dev/null; then
    echo "📦 Installing Flutter SDK..."
    curl -O https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.24.5-stable.tar.xz
    tar xf flutter_linux_3.24.5-stable.tar.xz
    export PATH="$PATH:`pwd`/flutter/bin:$PATH"
fi

echo "📦 Getting dependencies..."
flutter pub get

echo "🔨 Building Flutter web app..."
flutter build web --release

if [ $? -ne 0 ]; then
    echo "❌ Build failed!"
    exit 1
fi

echo "✅ Build successful!"
