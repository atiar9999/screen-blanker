#!/usr/bin/env python3
import tkinter as tk
import os
import sys

class UniversalBlanker:
    def __init__(self):
        # We don't force :0 here because the watcher.sh now exports the 
        # correct WAYLAND_DISPLAY or DISPLAY for us.
        
        try:
            self.root = tk.Tk()
        except tk.TclError:
            print("Could not connect to the graphical session. Exiting.")
            sys.exit(1)
        
        # 1. Setup Window
        # Removes borders (X11) and hints to the WM to stay out of the way
        self.root.overrideredirect(True) 
        
        # Wayland-friendly Fullscreen
        self.root.attributes('-fullscreen', True)
        
        # Safety for X11/High-end WMs
        self.root.attributes('-topmost', True)
        
        self.root.configure(background='black')
        self.root.config(cursor="none")

        # 2. State Management
        self.last_mouse_pos = None
        self.ready_to_exit = False
        
        # 500ms grace period so the F6 press itself doesn't close the window
        self.root.after(500, self.enable_exit)

        # 3. Bindings
        self.root.bind('<Any-KeyPress>', self.exit_app)
        self.root.bind('<Button-1>', self.exit_app)
        self.root.bind('<Motion>', self.handle_mouse)
        self.root.bind('<Escape>', self.exit_app)

        self.root.mainloop()

    def enable_exit(self):
        self.ready_to_exit = True

    def handle_mouse(self, event):
        if not self.ready_to_exit: return
        
        # Initial position capture
        if self.last_mouse_pos is None:
            self.last_mouse_pos = (event.x, event.y)
            return
            
        # Calculate movement delta (10px threshold for MSI Forge GM300 jitter)
        dx = abs(event.x - self.last_mouse_pos[0])
        dy = abs(event.y - self.last_mouse_pos[1])
        
        if dx > 10 or dy > 10:
            self.exit_app()

    def exit_app(self, event=None):
        self.root.destroy()

if __name__ == "__main__":
    UniversalBlanker()
