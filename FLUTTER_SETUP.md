# Flutter Integration Setup

This document explains how to integrate your Flutter app with the flexbuild system.

## Prerequisites

### 1. Flutter Engine Library
Download the Flutter engine library for embedded Linux:

```bash
# Download from Sony's flutter-embedded-linux releases
# https://github.com/sony/flutter-embedded-linux/releases

# Example for ARM64:
cd /Users/andrew/Documents/GitHub/flexbuild/flutter-engines/
wget https://github.com/sony/flutter-embedded-linux/releases/download/v3.16.9/elinux-arm64-release.zip
unzip elinux-arm64-release.zip
cp elinux-arm64-release/libflutter_engine.so ./
```

### 2. Flutter App Bundle
Place your Flutter app bundle in the flexbuild root:

```bash
# Copy your Flutter app tar file to flexbuild root
cp /path/to/your/flutter-app.tar.gz /Users/andrew/Documents/GitHub/flexbuild/
# OR
cp /path/to/your/flutter-app.tar /Users/andrew/Documents/GitHub/flexbuild/
```

## Build Process

### 1. Build with Flutter Support
```bash
# Build kernel with custom modules
bld -r debian:server -m imx8mp-var-dart -f sdk-var.yml uboot
bld -r poky:tiny -m imx8mp-var-dart -f sdk-var.yml -B fragment:custom.config linux


bld -r poky:tiny -m imx8mp-var-dart -f sdk-var.yml rfs
bld -r poky:tiny -m imx8mp-var-dart -f sdk-var.yml apps

bld -r poky:tiny -m imx8mp-var-dart -f sdk-var.yml merge-apps
bld -r poky:tiny -m imx8mp-var-dart -f sdk-var.yml merge-bootpart-rfs
bld -r poky:tiny -m imx8mp-var-dart -f sdk-var.yml packrfs
bld -r poky:tiny -m imx8mp-var-dart -f sdk-var.yml create-recovery-sdcard-image
```

## What Gets Installed

### Device Permissions
- `/etc/udev/rules.d/99-flutter.rules` - GPU, input, video, audio device permissions

### Environment Setup
- `/etc/profile.d/flutter.sh` - Flutter environment variables

### Flutter Components
- `/usr/lib/libflutter_engine.so` - Flutter engine library
- `/opt/flutter-app/` - Your Flutter application
- `/usr/local/bin/start-flutter-app.sh` - App startup script

### System Service
- `/etc/systemd/system/flutter-app.service` - Systemd service for auto-start

## Runtime Configuration

### Enable Flutter App Service
```bash
# On target system
systemctl enable flutter-app.service
systemctl start flutter-app.service
```

### Manual Start
```bash
# On target system
/usr/local/bin/start-flutter-app.sh
```

## Troubleshooting

### Check Service Status
```bash
systemctl status flutter-app.service
journalctl -u flutter-app.service -f
```

### Check Weston
```bash
systemctl status weston.service
ps aux | grep weston
```

### Check Permissions
```bash
groups flutter
ls -la /dev/dri/
ls -la /dev/input/
```

## File Structure Expected

Your Flutter app tar file should contain:
```
flutter-app/
├── flutter_app (or main)  # Executable
├── flutter_assets/        # Flutter assets
├── lib/                   # Additional libraries if needed
└── data/                  # App data if needed
```

## Environment Variables Set

- `XDG_RUNTIME_DIR=/tmp`
- `WAYLAND_DISPLAY=wayland-0`
- `QT_QPA_PLATFORM=wayland`
- `FLUTTER_ROOT=/opt/flutter`
- `LIBGL_ALWAYS_SOFTWARE=0`
- `MESA_GL_VERSION_OVERRIDE=3.3`
