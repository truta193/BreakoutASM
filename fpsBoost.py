import os, sys, time
import win32gui
import threading
from pynput import keyboard
from pynput.mouse import Button, Controller
from ctypes import windll, Structure, c_long, byref

WINDOWTITLE = "DXBallMegaCool"
FPS = 60
#Exit key is ESC

class POINT(Structure):
    _fields_ = [("x", c_long), ("y", c_long)]


def queryMousePosition():
    pt = POINT()
    windll.user32.GetCursorPos(byref(pt))
    return { "x": pt.x, "y": pt.y}

def on_press(key):
    global isRunning

    if key == keyboard.Key.esc:
        isRunning = False


def mouseClicker():
    mouse = Controller()

    while isRunning:
        dxball = win32gui.FindWindow(None, WINDOWTITLE)
        if not dxball:
            continue
        mouse_pos = queryMousePosition()
        win = win32gui.WindowFromPoint((mouse_pos.get("x"), mouse_pos.get("y")))
        if win == dxball:
            mouse.press(Button.left)
            mouse.release(Button.left)
            time.sleep(1/FPS)
        else:
            time.sleep(0.33)


isRunning = True
print("FPS Booster v1.1")
print("To stop the program, press ESC")

listener = keyboard.Listener(on_press=on_press)
listener.start()

thread = threading.Thread(target=mouseClicker)
thread.start()








# app = Application(backend="uia").connect(path="dxball.exe")
# print(app)
# elem = app.DXBallMegaCool
# elem.print_control_identifiers()
# while True:
#     time.sleep(0.001666666)
#     elem.click_input()