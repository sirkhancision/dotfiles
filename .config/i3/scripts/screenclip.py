#!/usr/bin/env python3.11

import os
import subprocess
import sys
from shutil import which


def check_dependencies(dependencies):
    """
    Check if the required programs are installed
    """
    missing_deps = [cmd for cmd in dependencies if which(cmd) is None]
    if missing_deps:
        print("The following dependencies are missing:")
        print("\n".join(missing_deps))
        sys.exit(1)


def screenclip(IMAGE_PATH):
    # use maim to select the area of the screen
    # and paplay to play a sound
    subprocess.run(["maim", "-s", IMAGE_PATH]) and subprocess.run(
        ["paplay", os.path.expanduser("~/.config/i3/audio/screen-capture.ogg")]
    )

    # send the image to the system's clipboard
    subprocess.run(
        ["xclip", "-selection", "clipboard", "-t", "image/png", "-i", IMAGE_PATH]
    )


def send_notification(IMAGE_NAME, IMAGE_PATH):
    NOTIFICATION_TEXT = f"<i>{IMAGE_NAME}</i>\nCopiado para a área de transferência"

    # sends notification with dunst
    subprocess.run(["dunstify", "Captura de tela", NOTIFICATION_TEXT, "-I", IMAGE_PATH])


def main():
    """
    Selects a part of the screen to screenshot, saves it to a file and sends it to the system's clipboard
    """
    dependencies = ["dunstify", "maim", "xclip", "xdg-user-dir"]

    check_dependencies(dependencies)

    PIC_DIR = subprocess.getoutput("xdg-user-dir PICTURES")
    IMAGE_NAME = subprocess.getoutput("date +%Y-%m-%d_%H-%M-%S") + ".png"
    SCREENSHOTS_DIR = os.path.join(PIC_DIR, "Screenshots")
    IMAGE_PATH = os.path.join(SCREENSHOTS_DIR, IMAGE_NAME)

    if not os.path.exists(SCREENSHOTS_DIR):
        os.makedirs(SCREENSHOTS_DIR)

    screenclip(IMAGE_PATH)

    send_notification(IMAGE_NAME, IMAGE_PATH)


if __name__ == "__main__":
    main()
