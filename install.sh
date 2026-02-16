#!/bin/bash

# --- 1. Tool Check & Installation ---
echo "Checking for required tools..."

# List of tools we need
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

# Check if each tool is installed
for tool in "${DEPENDENCIES[@]}"; do
    if ! command -v $tool &> /dev/null && ! dpkg -s $tool &> /dev/null; then
        echo "Installing missing dependency: $tool"
        install_tools
        break # Install them all at once
    fi
done

# --- 2. Setup Directories & Files ---
BIN_DIR="$HOME/.local/bin"
SERVICE_DIR="$HOME/.config/systemd/user"

mkdir -p "$BIN_DIR" "$SERVICE_DIR"

# Move files (assuming they are in the current Documents folder)
cp blanker.py "$BIN_DIR/blanker.py"
cp watcher.sh "$BIN_DIR/watcher.sh"
chmod +x "$BIN_DIR/blanker.py" "$BIN_DIR/watcher.sh"

# --- 3. Create the Service ---
cat <<EOF > "$SERVICE_DIR/f6-blanker.service"
[Unit]
Description=Universal F6 Screen Blanker
After=graphical-session.target

[Service]
ExecStart=/usr/bin/bash %h/.local/bin/watcher.sh
Restart=always
# Crucial: Ensures Tkinter can find your Dell monitor
Environment=DISPLAY=:0

[Install]
WantedBy=graphical-session.target
EOF

# --- 4. Permissions ---
echo "Granting $USER access to hardware input..."
sudo usermod -a -G input $USER

# --- 5. Final Activation ---
systemctl --user daemon-reload
systemctl --user enable f6-blanker.service
systemctl --user start f6-blanker.service

echo "-------------------------------------------------------"
echo "INSTALLATION COMPLETE!"
echo "Please LOG OUT and LOG BACK IN to apply group changes."
echo "Your MSI Mouse and PC Power K98 will now trigger F6."
echo "-------------------------------------------------------"
