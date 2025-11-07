#!/bin/bash

# Debug script to check kernel build status

echo "=== Kernel Build Debug ==="
echo "Current directory: $(pwd)"
echo "FBDIR: $FBDIR"

# Source the environment
source setup.env

# Set variables like flex-builder does
DESTARCH=arm64
SOCFAMILY=IMX
KERNEL_TREE=linux
FBOUTDIR=build_lsdk2412

echo ""
echo "=== Expected Paths ==="
echo "Kernel source should be in: $FBDIR/components_lsdk2412/linux/linux"
echo "Kernel output should be in: $FBOUTDIR/linux/$KERNEL_TREE/$DESTARCH/$SOCFAMILY"
echo "Kernel build output should be in: $FBOUTDIR/linux/$KERNEL_TREE/$DESTARCH/$SOCFAMILY/output"

echo ""
echo "=== Checking Kernel Source ==="
if [ -d "components_lsdk2412/linux/linux" ]; then
    echo "✓ Kernel source directory exists"
    cd components_lsdk2412/linux/linux
    echo "Current branch: $(git branch | grep ^* | cut -d' ' -f2)"
    echo "Last commit: $(git log --oneline -1)"
    cd - > /dev/null
else
    echo "✗ Kernel source directory missing"
fi

echo ""
echo "=== Checking Build Output Directory ==="
if [ -d "$FBOUTDIR/linux" ]; then
    echo "✓ Build linux directory exists"
    find $FBOUTDIR/linux -name "*.dtb" -o -name "Image*" -o -name "config-*" | head -10
else
    echo "✗ Build linux directory missing"
fi

echo ""
echo "=== Checking Expected Kernel Files ==="
expected_dir="$FBOUTDIR/linux/$KERNEL_TREE/$DESTARCH/$SOCFAMILY"
if [ -d "$expected_dir" ]; then
    echo "✓ Expected directory exists: $expected_dir"
    echo "Contents:"
    ls -la "$expected_dir"
else
    echo "✗ Expected directory missing: $expected_dir"
    echo "Creating directory..."
    mkdir -p "$expected_dir"
fi

echo ""
echo "=== Checking Kernel Output Directory ==="
output_dir="$FBOUTDIR/linux/$KERNEL_TREE/$DESTARCH/$SOCFAMILY/output"
if [ -d "$output_dir" ]; then
    echo "✓ Kernel output directory exists: $output_dir"
    # Look for built kernel files
    find "$output_dir" -name "Image*" -o -name "*.dtb" | head -5
else
    echo "✗ Kernel output directory missing: $output_dir"
fi

echo ""
echo "=== Checking for Built Kernel in Output ==="
if [ -d "$output_dir" ]; then
    # Check for the actual built files
    for branch_dir in "$output_dir"/*; do
        if [ -d "$branch_dir" ]; then
            echo "Branch directory: $branch_dir"
            if [ -f "$branch_dir/arch/arm64/boot/Image" ]; then
                echo "  ✓ Found Image in: $branch_dir/arch/arm64/boot/"
            fi
            if [ -d "$branch_dir/arch/arm64/boot/dts/freescale" ]; then
                echo "  ✓ Found DTB directory: $branch_dir/arch/arm64/boot/dts/freescale"
                ls "$branch_dir/arch/arm64/boot/dts/freescale/"*imx8mp-var-dart*.dtb 2>/dev/null | head -3
            fi
        fi
    done
fi

echo ""
echo "=== Recommendation ==="
echo "If kernel files are missing, try:"
echo "  bld linux -r poky:tiny -m imx8mp-var-dart -f sdk-var.yml"
