#!/bin/bash

# --- 1. Auto-detect Keyboard ---
KBD_EVENT=$(grep -E 'Handlers|EV=' /proc/bus/input/devices | \
            grep -B1 'EV=120013' | \
            grep -Eo 'event[0-9]+' | head -n 1)

if [ -z "$KBD_EVENT" ]; then
    echo "$(date '+%H:%M:%S') [ERROR] No keyboard detected via EV bitmask."
    exit 1
fi

DEVICE="/dev/input/$KBD_EVENT"
PYTHON_SCRIPT="$(dirname "$0")/blanker.py"

echo "=========================================="
echo "   F6 BLANKER LIVE LOG (Testing Mode)     "
echo "=========================================="
echo "$(date '+%H:%M:%S') [INIT] Device: $DEVICE"

# --- 2. Environment Detection ---
if [ -z "$DISPLAY" ] && [ -z "$WAYLAND_DISPLAY" ]; then
    # Find the user who is currently logged into the graphical session
    active_user=$(who | grep -m1 '(:[0-9])' | awk '{print $1}')
    [ -z "$active_user" ] && active_user=$(whoami)

    # Detect Wayland
    wayland_socket=$(ls /run/user/$(id -u $active_user)/wayland-* 2>/dev/null | head -n 1)
    
    if [ -n "$wayland_socket" ]; then
        export WAYLAND_DISPLAY=$(basename $wayland_socket)
        export XDG_RUNTIME_DIR="/run/user/$(id -u $active_user)"
        ENV_TYPE="Wayland (Auto-detected)"
        ENV_VARS="WAYLAND_DISPLAY=$WAYLAND_DISPLAY XDG_RUNTIME_DIR=$XDG_RUNTIME_DIR"
    else
        export DISPLAY=":0"
        # Grant root permission to open windows on the user's X11 screen
        xhost +SI:localuser:root > /dev/null 2>&1
        ENV_TYPE="X11 (Auto-detected)"
        ENV_VARS="DISPLAY=$DISPLAY"
    fi
else
    # Variables already exist (manual run)
    ENV_VARS="DISPLAY=$DISPLAY WAYLAND_DISPLAY=$WAYLAND_DISPLAY XDG_RUNTIME_DIR=$XDG_RUNTIME_DIR"
    ENV_TYPE="Manual Session"
fi

echo "$(date '+%H:%M:%S') [INIT] Detected Environment: $ENV_TYPE"

# --- 3. Monitor and Trigger ---

stdbuf -oL evtest "$DEVICE" | while read line; do
    if [[ "$line" == *"(KEY_F6), value 1"* ]]; then
        echo "$(date '+%H:%M:%S') [ACTION] F6 Pressed!"

        # Check if already running
        if pgrep -f "blanker.py" > /dev/null; then
            echo "$(date '+%H:%M:%S') [SKIP] Blanker already active."
        else
            echo "$(date '+%H:%M:%S') [EXEC] Launching $PYTHON_SCRIPT"
            
            # Wrap in a subshell to log when it finishes (mouse movement/key press)
            (
                export $ENV_VARS
                python3 "$PYTHON_SCRIPT"
                echo "$(date '+%H:%M:%S') [EXIT] Blanker closed by user."
            ) &
        fi
    fi
done
