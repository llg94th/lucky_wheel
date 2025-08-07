#!/bin/bash

# Build Flutter web app for GitHub Pages
# This script builds the web app with the correct base href for the lucky_wheel repository

echo "🚀 Building Flutter web app for GitHub Pages..."

# Clean previous build
echo "🧹 Cleaning previous build..."
flutter clean

# Get dependencies
echo "📦 Getting dependencies..."
flutter pub get

# Build web app with correct base href for GitHub Pages
echo "🔨 Building web app..."
flutter build web \
  --base-href "/lucky_wheel/" \
  --release \
  --web-renderer canvaskit

# Copy build files to docs directory
echo "📁 Copying build files to docs directory..."
rm -rf docs/*
cp -r build/web/* docs/

echo "✅ Build completed successfully!"
echo "📂 Build files are now in the /docs directory"
echo "🌐 Your app will be available at: https://llg94th.github.io/lucky_wheel/" 