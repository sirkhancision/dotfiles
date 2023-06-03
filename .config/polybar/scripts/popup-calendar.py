#!/usr/bin/env python3

import argparse
import re
import subprocess
import sys
from shutil import which

BAR_HEIGHT = 24  # polybar height
BORDER_SIZE = 1  # border size from your wm settings
YAD_WIDTH = 222  # 222 is minimum possible value
YAD_HEIGHT = 193  # 193 is minimum possible value
ICON = ""


def check_dependencies(dependencies):
    """
    Check if the required programs are installed
    """
    missing_deps = [cmd for cmd in dependencies if which(cmd) is None]
    if missing_deps:
        print("The following dependencies are missing:")
        print("\n".join(missing_deps))
        sys.exit(1)


def handle_error(error):
    """
    Prints a custom message for an error and exits
    """
    print(error)
    sys.exit(1)


def get_window_name():
    """
    Gets the focused window's name
    """
    try:
        window_name = subprocess.run(
            ["xdotool", "getwindowfocus", "getwindowname"],
            capture_output=True,
            text=True).stdout
    except subprocess.CalledProcessError:
        handle_error("Could not get the active window's name")

    return window_name


def get_mouse_location():
    """
    Gets the mouse's location in the screen
    """
    try:
        mouse_location = subprocess.run(["xdotool", "getmouselocation"],
                                        capture_output=True,
                                        text=True).stdout
    except subprocess.CalledProcessError:
        handle_error("Could not get the mouse's location")

    mouse_location = re.findall(r"\b.:(\d+)", mouse_location)
    mouse_x, mouse_y = int(mouse_location[0]), int(mouse_location[1])

    return mouse_x, mouse_y


def get_screen_resolution():
    """
    Gets the screen's resolution
    """
    try:
        screen_resolution = subprocess.run(["xdotool", "getdisplaygeometry"],
                                           capture_output=True,
                                           text=True).stdout.split()
    except subprocess.CalledProcessError:
        handle_error("Could not get the screen's resolution")

    screen_width, screen_height = int(screen_resolution[0]), int(
        screen_resolution[1])
    return screen_width, screen_height


def get_yad_position(YAD_WIDTH, YAD_HEIGHT, BORDER_SIZE, BAR_HEIGHT, mouse_x,
                     mouse_y, screen_width, screen_height):
    """
    Gets the position where yad-calendar will be opened at
    """
    if (mouse_x + YAD_WIDTH / 2 + BORDER_SIZE) > screen_width:
        position_x = screen_width - YAD_WIDTH - BORDER_SIZE - 30
    elif (mouse_x - YAD_WIDTH / 2 - BORDER_SIZE) < 0:
        position_x = BORDER_SIZE
    else:
        position_x = mouse_x - YAD_WIDTH / 2

    if mouse_y > screen_height / 2:
        position_y = screen_height - YAD_HEIGHT - BAR_HEIGHT - BORDER_SIZE
    else:
        position_y = BAR_HEIGHT + BORDER_SIZE

    return position_x, position_y


def show_popup():
    """
    Opens yad-calendar as a popup in a corner of the screen
    """
    global BAR_HEIGHT, BORDER_SIZE, YAD_WIDTH, YAD_HEIGHT, ICON

    window_name = get_window_name()

    # if yad-calendar is open and focused, do nothing
    if window_name == "yad-calendar":
        sys.exit(0)

    mouse_x, mouse_y = get_mouse_location()

    screen_width, screen_height = get_screen_resolution()

    # position of the popup
    position_x, position_y = get_yad_position(YAD_WIDTH, YAD_HEIGHT,
                                              BORDER_SIZE, BAR_HEIGHT, mouse_x,
                                              mouse_y, screen_width,
                                              screen_height)

    try:
        subprocess.run([
            "yad", "--calendar", "--undecorated", "--fixed",
            "--close-on-unfocus", "--no-buttons", f"--width={YAD_WIDTH}",
            f"height={YAD_HEIGHT}", f"--posx={position_x}",
            f"--posy={position_y}", '--title="yad-calendar"', "--borders=0"
        ])
    except subprocess.CalledProcessError:
        handle_error("Could not print yad-calendar")


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--popup",
                        action="store_true",
                        help="Show yad-calendar as a popup")
    args = parser.parse_args()

    dependencies = ["xdotool", "yad"]
    check_dependencies(dependencies)

    if args.popup:
        show_popup()
    else:
        global ICON
        print(ICON)


if __name__ == "__main__":
    main()
