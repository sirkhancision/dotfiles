#!/usr/bin/env python3

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
        raise SystemExit("The following dependencies are missing:" +
                         "\n".join(missing_deps))


def windowshot(IMAGE_PATH):
    subprocess.run(["grimshot", "save", "active", IMAGE_PATH])

    if os.path.isfile(IMAGE_PATH):
        subprocess.run([
            "paplay",
            os.path.expanduser("~/.config/sway/audio/screen-capture.ogg")
        ])

    subprocess.run(["wl-copy", "--type", "image/png"],
                   input=open(IMAGE_PATH, "rb").read())


def send_notification(IMAGE_NAME, IMAGE_PATH):
    NOTIFICATION_TEXT = (f"<i>{IMAGE_NAME}</i>\n"
                         "Copiado para a área de transferência")

    subprocess.run(
        ["dunstify", "Captura de tela", NOTIFICATION_TEXT, "-I", IMAGE_PATH])


def main():
    """
    Screenshots the active window, saves it to a file and sends it
    to the system's clipboard
    """
    dependencies = ["dunstify", "grimshot", "wl-copy", "xdg-user-dir"]

    try:
        check_dependencies(dependencies)
    except SystemExit as e:
        print(e)
        sys.exit(1)

    PIC_DIR = subprocess.getoutput("xdg-user-dir PICTURES")
    IMAGE_NAME = subprocess.getoutput("date +%Y-%m-%d_%H-%M-%S") + ".png"
    SCREENSHOTS_DIR = os.path.join(PIC_DIR, "Screenshots")
    IMAGE_PATH = os.path.join(SCREENSHOTS_DIR, IMAGE_NAME)

    if not os.path.exists(SCREENSHOTS_DIR):
        os.makedirs(SCREENSHOTS_DIR)

    windowshot(IMAGE_PATH)

    send_notification(IMAGE_NAME, IMAGE_PATH)


if __name__ == "__main__":
    main()
