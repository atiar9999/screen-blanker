#!/usr/bin/env python3
import tkinter as tk
import sys

class UniversalBlanker:
    def __init__(self):
        try:
            self.root = tk.Tk()
        except tk.TclError:
            print("Could not connect to graphical session.")
            sys.exit(1)
        
        # 1. Start hidden to prevent the "small box" flash
        self.root.withdraw()
        self.root.configure(background='black')
        self.root.config(cursor="none")

        # 2. X11 / MX Linux Specific Tweaks
        # This hint tells Xfce to treat this like a "splash" screen, 
        # which helps bypass window manager borders.
        try:
            self.root.attributes('-type', 'splash')
        except:
            pass # Ignore if not on X11
            
        # 3. State Management
        self.last_mouse_pos = None
        self.ready_to_exit = False
        self.root.after(500, self.enable_exit)

        # 4. Bindings
        self.root.bind('<Any-KeyPress>', self.exit_app)
        self.root.bind('<Button-1>', self.exit_app)
        self.root.bind('<Motion>', self.handle_mouse)
        self.root.bind('<Escape>', self.exit_app)

        # 5. The "Universal" Activation
        # We wait 100ms for VirtualBox/MX to report the correct resolution
        self.root.after(100, self.force_fullscreen)
        
        self.root.mainloop()

    def force_fullscreen(self):
        # Get dimensions again (more accurate after a short delay)
        w = self.root.winfo_screenwidth()
        h = self.root.winfo_screenheight()
        
        # Set geometry AND fullscreen attribute
        self.root.overrideredirect(True)
        self.root.geometry(f"{w}x{h}+0+0")
        self.root.attributes('-topmost', True)

        # 5. Keep the fullscreen attribute for non-KDE environments
        try:
            self.root.attributes('-fullscreen', True)
        except:
            pass
        
        # Bring it to life
        self.root.deiconify()
        self.root.focus_force()

    def enable_exit(self):
        self.ready_to_exit = True

    def handle_mouse(self, event):
        if not self.ready_to_exit: return
        if self.last_mouse_pos is None:
            self.last_mouse_pos = (event.x, event.y)
            return
            
        dx = abs(event.x - self.last_mouse_pos[0])
        dy = abs(event.y - self.last_mouse_pos[1])
        
        # 10px jitter threshold (perfect for your MSI Forge GM300)
        if dx > 10 or dy > 10:
            self.exit_app()

    def exit_app(self, event=None):
        self.root.destroy()

if __name__ == "__main__":
    UniversalBlanker()
