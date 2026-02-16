#!/usr/bin/env python3
import tkinter as tk
import time

class UniversalBlanker:
    def __init__(self):
        self.root = tk.Tk()
        
        # 1. Universal Setup
        self.root.configure(background='black')
        self.root.attributes('-fullscreen', True)
        self.root.attributes('-topmost', True)
        self.root.config(cursor="none")
        self.root.title("Overlay") # Helps window managers identify it

        # 2. Prevent accidental exit (Mouse Jitter)
        self.last_x = None
        self.last_y = None
        self.start_time = time.time()

        # 3. Bindings
        self.root.bind('<Any-KeyPress>', self.exit_app)
        self.root.bind('<Button-1>', self.exit_app)
        self.root.bind('<Motion>', self.handle_mouse)

        self.root.mainloop()

    def handle_mouse(self, event):
        # Ignore movement for the first 0.5 seconds (grace period)
        if time.time() - self.start_time < 0.5:
            return

        # Initialize coordinates
        if self.last_x is None:
            self.last_x, self.last_y = event.x, event.y
            return

        # Exit only if mouse moves more than 5 pixels 
        # (Accounts for high-DPI sensors like your MSI Forge GM300)
        if abs(event.x - self.last_x) > 5 or abs(event.y - self.last_y) > 5:
            self.exit_app()

    def exit_app(self, event=None):
        self.root.destroy()

if __name__ == "__main__":
    UniversalBlanker()
