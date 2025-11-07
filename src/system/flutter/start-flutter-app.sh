#!/bin/bash
# Flutter App Startup Script

# Source Flutter environment
source /etc/profile.d/flutter.sh

# Wait for Weston to be ready
echo "Waiting for Weston compositor..."
timeout=30
while [ $timeout -gt 0 ]; do
    if [ -S "$XDG_RUNTIME_DIR/$WAYLAND_DISPLAY" ]; then
        echo "Weston is ready"
        break
    fi
    sleep 1
    timeout=$((timeout - 1))
done

if [ $timeout -eq 0 ]; then
    echo "Timeout waiting for Weston compositor"
    exit 1
fi

# Change to Flutter app directory
cd /opt/flutter-app

# Check if Flutter app exists
if [ ! -f "./flutter_app" ] && [ ! -f "./main" ]; then
    echo "Flutter app executable not found in /opt/flutter-app"
    echo "Looking for 'flutter_app' or 'main' executable"
    ls -la /opt/flutter-app/
    exit 1
fi

# Launch Flutter app
echo "Starting Flutter app..."
if [ -f "./flutter_app" ]; then
    exec ./flutter_app
elif [ -f "./main" ]; then
    exec ./main
else
    echo "No Flutter app executable found"
    exit 1
fi
