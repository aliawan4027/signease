#!/bin/bash

echo "🚀 Building Flutter app for Vercel deployment..."

# Install Flutter if not available
if ! command -v flutter &> /dev/null; then
    echo "📦 Installing Flutter SDK..."
    curl -O https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.24.5-stable.tar.xz
    tar xf flutter_linux_3.24.5-stable.tar.xz
    export PATH="$PATH:`pwd`/flutter/bin:$PATH"
fi

# Clean and build
echo "🧹 Cleaning previous build..."
flutter clean

echo "📦 Getting dependencies..."
flutter pub get

echo "🔨 Building Flutter web app..."
flutter build web --release

# Check if build was successful
if [ $? -eq 0 ]; then
    echo "✅ Build successful!"
    
    # Navigate to build directory
    cd build/web
    
    # Deploy to Vercel
    echo "🌐 Deploying to Vercel..."
    vercel --prod
    
    if [ $? -eq 0 ]; then
        echo "🎉 Deployment successful!"
        echo "📱 Your app is now live on Vercel!"
    else
        echo "❌ Deployment failed!"
        exit 1
    fi
else
    echo "❌ Build failed!"
    exit 1
fi
