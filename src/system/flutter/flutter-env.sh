#!/bin/bash
# Flutter environment setup script

# Wayland/Weston environment
export XDG_RUNTIME_DIR=/tmp
export WAYLAND_DISPLAY=wayland-0
export QT_QPA_PLATFORM=wayland

# Graphics environment
export LIBGL_ALWAYS_SOFTWARE=0
export MESA_GL_VERSION_OVERRIDE=3.3

# Flutter-specific paths
export FLUTTER_ROOT=/opt/flutter
export PATH=$FLUTTER_ROOT/bin:$PATH

# Ensure runtime directory exists
mkdir -p $XDG_RUNTIME_DIR
chmod 0700 $XDG_RUNTIME_DIR
