#!/usr/bin/env python3
import tkinter as tk

def close_window(event=None):
    """Close the window on any event"""
    root.destroy()

# Create the main window
root = tk.Tk()

# Make it fullscreen and black
root.attributes('-fullscreen', True)
root.attributes('-topmost', True)
root.configure(background='black', cursor='none')

# Bind mouse movement to close
root.bind('<Motion>', close_window)

# Bind any key press to close
root.bind('<Key>', close_window)

# Bind mouse clicks to close
root.bind('<Button>', close_window)

# Start the GUI
root.mainloop()
