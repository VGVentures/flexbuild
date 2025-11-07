#!/bin/bash

# Force clean all Flutter/Yocto related directories and start fresh

echo "=== Force Cleaning Flutter/Yocto Build Environment ==="

# Clean up all meta_flutter directories
echo "Removing all meta_flutter directories..."
find . -name "meta_flutter" -type d -exec rm -rf {} + 2>/dev/null || true

# Clean up all Yocto build directories
echo "Removing Yocto build directories..."
rm -rf build_lsdk2412/rfs/rootfs_*poky* 2>/dev/null || true
rm -rf components_lsdk2412/yocto 2>/dev/null || true

# Clean up any cached bitbake data
echo "Cleaning bitbake cache..."
rm -rf build_lsdk2412/cache 2>/dev/null || true

# Clean up any temporary build files
echo "Cleaning temporary build files..."
find . -name "*.tmp*" -type d -exec rm -rf {} + 2>/dev/null || true

# Ensure the configuration is correct
echo "Verifying Flutter configuration..."

# Check if meta_flutter URL is correct in sdk-var.yml
if grep -q "sony/meta-flutter" configs/sdk-var.yml; then
    echo "Fixing meta_flutter repository URL..."
    sed -i 's|url:.*sony/meta-flutter.git|url:  https://github.com/meta-flutter/meta-flutter.git|' configs/sdk-var.yml
fi

# Check if branch is correct
if grep -q "branch: main" configs/sdk-var.yml; then
    echo "Fixing meta_flutter branch..."
    sed -i 's/branch: main/branch: scarthgap/' configs/sdk-var.yml
fi

echo ""
echo "=== Cleanup Complete ==="
echo ""
echo "Current meta_flutter configuration:"
grep -A2 "meta_flutter:" configs/sdk-var.yml
echo ""
echo "You can now run:"
echo "  bld docker-user"
echo "  bld rfs -r poky:tiny -m imx8mp-var-dart -f sdk-var.yml"
echo ""
echo "This will clone the correct meta-flutter repository with scarthgap compatibility."
