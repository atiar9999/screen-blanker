#!/bin/bash

echo "Starting uninstallation of F6 Screen Blanker..."

# --- 1. Variables (Must match installer) ---
BIN_DIR="$HOME/.local/bin"
AUTOSTART_DIR="$HOME/.config/autostart"

# --- 2. Stop Running Processes ---
echo "Stopping active processes..."
pkill -f watcher.sh
pkill -f blanker.py

# --- 3. Remove Files ---
echo "Removing files..."
rm -f "$BIN_DIR/blanker.py"
rm -f "$BIN_DIR/watcher.sh"
rm -f "$AUTOSTART_DIR/f6-blanker.desktop"

# --- 4. Cleanup Systemd (If any remnants exist) ---
if [ -f "$HOME/.config/systemd/user/f6-blanker.service" ]; then
    systemctl --user stop f6-blanker.service 2>/dev/null
    systemctl --user disable f6-blanker.service 2>/dev/null
    rm "$HOME/.config/systemd/user/f6-blanker.service"
    systemctl --user daemon-reload
fi

# --- 5. Optional: Hardware Permissions ---
# Note: We usually don't remove the user from the 'input' group automatically 
# because other apps might need it, but here is how you'd do it manually:
# sudo gpasswd -d $USER input

echo "-------------------------------------------------------"
echo "UNINSTALLATION COMPLETE!"
echo "-------------------------------------------------------"
echo "1. Files removed from $BIN_DIR"
echo "2. Autostart entry removed."
echo "3. Processes killed."
echo "-------------------------------------------------------"
