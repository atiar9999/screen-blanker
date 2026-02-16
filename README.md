
 🖥️ Screen Blanker (F6 Privacy Shortcut)

A lightweight Python utility that instantly blanks your screen when you press **F6** and automatically restores it when you move your mouse or press any key.

This tool is useful for quickly hiding your screen for privacy or focus.

---
✨ Features

* Instant fullscreen black screen overlay
* Activated with a single key (F6)
* Automatically exits on:

  * Mouse movement
  * Mouse click
  * Keyboard input
* Hides mouse cursor while active
* Lightweight and fast

---

 📦 Installation & Setup


 📋 Requirements

This script requires **Tkinter** (Python GUI library).

### Install Tkinter

#### Debian / Ubuntu

```bash
sudo apt install python3-tk
```

#### Fedora

```bash
sudo dnf install python3-tkinter
```

#### Arch Linux

```bash
sudo pacman -S tk
```

1. Save the Script

Move the script to a permanent directory and make it executable:

```bash
mkdir -p ~/scripts
mv ~/Downloads/screen_blanker.py ~/scripts/
chmod +x ~/scripts/screen_blanker.py
```

---
 2. Assign F6 Keyboard Shortcut (Xfce)

1. Open **Settings Manager**
2. Go to **Keyboard**
3. Select **Application Shortcuts** tab
4. Click **Add**
5. Enter this command:

```bash
python3 /home/goplunaplu/scripts/screen_blanker.py
```

6. Click OK
7. Press *F6* when prompted

---

3. Test

* Press **F6** → Screen turns black
* Move mouse or press any key → Screen restores instantly

---

⚙️ How It Works

The script:

* Creates a fullscreen black window above all other windows
* Hides the cursor
* Listens for user input events
* Closes immediately when input is detected

---

🛡️ Use Cases

* Short-Break
* Hide screen during interruptions
* Focus sessions
* Presentation standby screen

