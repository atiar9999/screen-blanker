[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
[![Python: 3.x](https://img.shields.io/badge/Language-Python_3-3776AB.svg?logo=python&logoColor=white)](https://python.org)
[![OS: Linux](https://img.shields.io/badge/OS-Linux-FCC624.svg?logo=linux&logoColor=black)](https://kernel.org)

# Universal Linux F6 Screen Blanker

A lightweight, hardware-level screen blanker for Linux that triggers a total black-out when **F6** is pressed. Unlike standard screensavers, this listens directly to the kernel input events, making it compatible across all Desktop Environments (GNOME, KDE, XFCE) and Window Managers.



## 🚀 Features
- **Environment Agnostic:** Works on X11 and Wayland by monitoring `/dev/input`.
- **Hardware Direct:** Auto-detects your keyboard.
- **Smart Sensitivity:** Prevents accidental exits from high-DPI mouse jitter.
- **Low Resource:** Minimal CPU impact; sits idle until the interrupt is triggered.

## 🛠 Prerequisites
The installation script handles these automatically, but for reference:
- `python3` & `python3-tk` (For the overlay UI)
- `evtest` (To monitor hardware events)
- `systemd` (To run the watcher in the background)

## 📦 Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/atiar9999/screen-blanker.git
   cd screen-blanker
   ```

2. **Run the installer:**
   ```bash
   chmod +x install.sh
   ./install.sh
   ```

3. **Finalize:**
   You must log out and log back in (or reboot). This allows the system to apply the new `input` group permissions so the script can read your keyboard events without needing `sudo` every time.

## 🖥 How it Works
1. **Watcher:** A Bash script uses `evtest` to monitor your keyboard's event slot.
2. **Trigger:** When the hex code for `F6` is detected, it launches the Python script.
3. **Overlay:** The Python script creates a black, fullscreen, "topmost" Tkinter window.
4. **Exit:** Pressing any key or moving the mouse more than 10 pixels destroys the window.

## 🔧 Configuration
If you want to change the trigger key or the mouse sensitivity:
- **Change Key:** Edit `watcher.sh` and replace `KEY_F6` with your preferred key (run `sudo evtest` to find your key codes).
- **Adjust Sensitivity:** Edit `blanker.py` and change the `dx > 10` threshold in the `handle_mouse` function.

## 📜 License

This project is licensed under the **MIT License**. See the [LICENSE](LICENSE) file for details.
