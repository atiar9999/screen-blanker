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
if [ -n "$WAYLAND_DISPLAY" ]; then
    ENV_VARS="WAYLAND_DISPLAY=$WAYLAND_DISPLAY"
    ENV_TYPE="Wayland"
elif [ -n "$DISPLAY" ]; then
    ENV_VARS="DISPLAY=$DISPLAY"
    ENV_TYPE="X11"
else
    ENV_VARS="DISPLAY=:0"
    ENV_TYPE="X11 (Fallback)"
fi

echo "$(date '+%H:%M:%S') [INIT] Detected Environment: $ENV_TYPE ($ENV_VARS)"
echo "$(date '+%H:%M:%S') [INIT] Status: Monitoring for F6..."

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
