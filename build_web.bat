@echo off

REM Build Flutter web app for GitHub Pages
REM This script builds the web app with the correct base href for the lucky_wheel repository

echo 🚀 Building Flutter web app for GitHub Pages...

REM Clean previous build
echo 🧹 Cleaning previous build...
flutter clean

REM Get dependencies
echo 📦 Getting dependencies...
flutter pub get

REM Build web app with correct base href for GitHub Pages
echo 🔨 Building web app...
flutter build web --base-href "/lucky_wheel/" --release --web-renderer canvaskit

REM Copy build files to docs directory
echo 📁 Copying build files to docs directory...
if exist docs rmdir /s /q docs
mkdir docs
xcopy /e /i build\web docs

echo ✅ Build completed successfully!
echo 📂 Build files are now in the /docs directory
echo 🌐 Your app will be available at: https://llg94th.github.io/lucky_wheel/

pause 