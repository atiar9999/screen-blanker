# Universal Linux F6 Screen Blanker

A lightweight, hardware-level screen blanker for Linux that triggers a total black-out when **F6** is pressed. Unlike standard screensavers, this listens directly to the kernel input events, making it compatible across all Desktop Environments (GNOME, KDE, XFCE) and Window Managers.



## 🚀 Features
- **Environment Agnostic:** Works on X11 and Wayland by monitoring `/dev/input`.
- **Hardware Direct:** Auto-detects your keyboard (tested on PC Power K98).
- **Smart Sensitivity:** Prevents accidental exits from high-DPI mouse jitter (optimized for MSI Forge GM300).
- **Low Resource:** Minimal CPU impact; sits idle until the interrupt is triggered.

## 🛠 Prerequisites
The installation script handles these automatically, but for reference:
- `python3` & `python3-tk` (For the overlay UI)
- `evtest` (To monitor hardware events)
- `systemd` (To run the watcher in the background)

## 📦 Installation

1. **Clone the repository:**
   ```bash
   git clone [https://github.com/yourusername/f6-blanker.git](https://github.com/yourusername/f6-blanker.git)
   cd f6-blanker
   ```

2. **Run the installer:**
   ```bash
   chmod +x install.sh
   ./install.sh
   ```

3. **Finalize:**
   You must log out and log back in (or reboot). This allows the system to apply the new input group permissions so the script can read your keyboard events without needing sudo every time.
