#!/bin/bash

# --- 1. Tool Check & Installation ---
echo "Checking for required tools..."
DEPENDENCIES=("evtest" "python3" "python3-tk" "coreutils")

install_tools() {
    if [ -f /usr/bin/apt ]; then
        sudo apt update && sudo apt install -y evtest python3 python3-tk
    elif [ -f /usr/bin/pacman ]; then
        sudo pacman -Sy --noconfirm evtest python3 tk
    elif [ -f /usr/bin/dnf ]; then
        sudo dnf install -y evtest python3 python3-tkinter
    else
        echo "Unknown package manager. Please install evtest and python-tk manually."
    fi
}

for tool in "${DEPENDENCIES[@]}"; do
    if ! command -v $tool &> /dev/null; then
        echo "Installing missing dependency: $tool"
        install_tools
        break 
    fi
done

# --- 2. Setup Directories ---
BIN_DIR="$HOME/.local/bin"
AUTOSTART_DIR="$HOME/.config/autostart"

mkdir -p "$BIN_DIR" "$AUTOSTART_DIR"

# Move files to local bin
cp blanker.py "$BIN_DIR/blanker.py"
cp watcher.sh "$BIN_DIR/watcher.sh"
chmod +x "$BIN_DIR/blanker.py" "$BIN_DIR/watcher.sh"

# --- 3. Cleanup Old Systemd Service (If exists) ---
if [ -f "$HOME/.config/systemd/user/f6-blanker.service" ]; then
    echo "Cleaning up old systemd service..."
    systemctl --user stop f6-blanker.service 2>/dev/null
    systemctl --user disable f6-blanker.service 2>/dev/null
    rm "$HOME/.config/systemd/user/f6-blanker.service"
    systemctl --user daemon-reload
fi

# --- 4. Create Desktop Autostart Entry ---
# This works for Xfce, GNOME, KDE, etc.
cat <<EOF > "$AUTOSTART_DIR/f6-blanker.desktop"
[Desktop Entry]
Type=Application
Name=F6 Screen Blanker
Comment=Monitors F6 for screen blanking
Exec=/usr/bin/bash $BIN_DIR/watcher.sh
Terminal=false
X-GNOME-Autostart-enabled=true
X-KDE-autostart-after=panel
Categories=Utility;
EOF

# --- 5. Permissions ---
echo "Granting $USER access to hardware input..."
sudo usermod -a -G input $USER

echo "-------------------------------------------------------"
echo "INSTALLATION COMPLETE!"
echo "-------------------------------------------------------"
echo "CRITICAL STEPS FOR SUCCESS:"
echo "1. LOG OUT and LOG BACK IN (required for input permissions)."
echo "2. The blanker will now start automatically with your desktop."
echo "3. To verify it is running after login, use:"
echo "   ps aux | grep watcher.sh"
echo "-------------------------------------------------------"
