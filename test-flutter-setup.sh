#!/bin/bash
# Test script to verify Flutter setup

echo "=== Flutter Integration Test ==="

# Check if Flutter engine exists
if [ -f "flutter-engines/libflutter_engine.so" ]; then
    echo "✓ Flutter engine library found"
    ls -la flutter-engines/libflutter_engine.so
else
    echo "✗ Flutter engine library NOT found"
    echo "  Please download from https://github.com/sony/flutter-embedded-linux/releases"
fi

# Check if Flutter app exists
if [ -f "flutter-app.tar.gz" ]; then
    echo "✓ Flutter app bundle found (tar.gz)"
    ls -la flutter-app.tar.gz
elif [ -f "flutter-app.tar" ]; then
    echo "✓ Flutter app bundle found (tar)"
    ls -la flutter-app.tar
else
    echo "✗ Flutter app bundle NOT found"
    echo "  Please place your flutter-app.tar.gz or flutter-app.tar in the flexbuild root"
fi

# Check if Flutter components exist
echo ""
echo "=== Flutter Components ==="
components=(
    "src/system/udev/udev-rules-flutter/99-flutter.rules"
    "src/system/flutter/flutter-env.sh"
    "src/system/flutter/start-flutter-app.sh"
    "src/system/flutter/flutter-app.service"
    "src/apps/utils/flutter_app.mk"
)

for component in "${components[@]}"; do
    if [ -f "$component" ]; then
        echo "✓ $component"
    else
        echo "✗ $component"
    fi
done

echo ""
echo "=== Build Commands ==="
echo "1. Build kernel with custom modules:"
echo "   flex-builder -r poky:tiny -m imx8mp-var-dart -f sdk-var.yml -B fragment:custom.config linux"
echo ""
echo "2. Build rootfs with Flutter support:"
echo "   flex-builder -r poky:tiny -m imx8mp-var-dart -f sdk-var.yml rfs"
echo ""
echo "3. Build apps (including Flutter app):"
echo "   flex-builder -r poky:tiny -m imx8mp-var-dart -f sdk-var.yml apps"
