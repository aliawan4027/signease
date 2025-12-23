#!/bin/bash

# Flutter Web Deployment Script for Vercel

echo "🚀 Starting Flutter Web Deployment to Vercel..."

# Clean previous build
echo "🧹 Cleaning previous build..."
flutter clean

# Get dependencies
echo "📦 Getting dependencies..."
flutter pub get

# Build for web
echo "🔨 Building Flutter web app..."
flutter build web --release

# Check if build was successful
if [ $? -eq 0 ]; then
    echo "✅ Build successful!"
    
    # Navigate to build directory
    cd build/web
    
    # Check if vercel.json exists
    if [ ! -f "vercel.json" ]; then
        echo "⚠️  vercel.json not found, creating default..."
        cat > vercel.json << EOF
{
  "version": 2,
  "builds": [
    {
      "src": "web",
      "use": "@vercel/static",
      "config": {
        "source": "web/build"
      }
    }
  ],
  "routes": [
    {
      "src": "web",
      "dest": "/"
    }
  ]
}
EOF
    fi
    
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
