#!/usr/bin/env python3

import argparse
import json
import subprocess
import sys
from shutil import which

BAR_HEIGHT = 24  # polybar height
BORDER_SIZE = 3  # border size from your wm settings
YAD_WIDTH = 222  # 222 is minimum possible value
YAD_HEIGHT = 193  # 193 is minimum possible value
ICON = ""


def check_dependencies(dependencies):
    """
    Check if the required programs are installed
    """
    missing_deps = [cmd for cmd in dependencies if which(cmd) is None]
    if missing_deps:
        raise SystemExit("The following dependencies are missing:" +
                         "\n".join(missing_deps))


def find_focused_node(nodes):
    """
    Get the focused Sway node
    """
    stack = list(nodes)

    while stack:
        node = stack.pop()

        if node.get("focused"):
            return node

        if "nodes" in node:
            stack.extend(node["nodes"])

    return None


def get_window_name():
    """
    Get the focused window's name
    """
    try:
        sway_tree = subprocess.run(["swaymsg", "-t", "get_tree"],
                                   capture_output=True,
                                   text=True)
    except subprocess.CalledProcessError as e:
        raise subprocess.CalledProcessError(
            "Could not get the active window's name: " + str(e))

    sway_tree = json.loads(sway_tree.stdout)

    focused_node = find_focused_node(sway_tree["nodes"])

    if focused_node:
        window_name = focused_node.get("name")
    else:
        window_name = None

    return window_name


def get_screen_resolution():
    """
    Gets the screen's resolution
    """
    try:
        screen_resolution = subprocess.run(["swaymsg", "-t", "get_outputs"],
                                           capture_output=True,
                                           text=True)
    except subprocess.CalledProcessError as e:
        raise subprocess.CalledProcessError(
            "Could not get the screen's resolution: " + str(e))

    outputs = json.loads(screen_resolution.stdout)
    focused_output = next(
        (output for output in outputs if output.get("focused")), None)

    if focused_output:
        screen_width = focused_output["current_mode"]["width"]
        screen_height = focused_output["current_mode"]["height"]
    else:
        raise ValueError("Could not get the screen's resolution")

    return screen_width, screen_height


def get_yad_position(YAD_WIDTH, YAD_HEIGHT, BORDER_SIZE, BAR_HEIGHT, mouse_x,
                     mouse_y, screen_width, screen_height):
    """
    Gets the position where yad-calendar will be opened at
    """
    position_x = (screen_width - YAD_WIDTH - BORDER_SIZE - 30 if mouse_x +
                  YAD_WIDTH / 2 +
                  BORDER_SIZE > screen_width else BORDER_SIZE if mouse_x -
                  YAD_WIDTH / 2 - BORDER_SIZE < 0 else mouse_x - YAD_WIDTH / 2)

    position_y = (screen_height - YAD_HEIGHT - BAR_HEIGHT -
                  BORDER_SIZE if mouse_y > screen_height / 2 else BAR_HEIGHT +
                  BORDER_SIZE)

    print(position_x, position_y)

    return position_x, position_y


def show_popup():
    """
    Opens yad-calendar as a popup in a corner of the screen
    """
    global BAR_HEIGHT, BORDER_SIZE, YAD_WIDTH, YAD_HEIGHT, ICON

    window_name = get_window_name()

    # if yad-calendar is open and focused, do nothing
    if window_name == "yad-calendar":
        return

    mouse_x, mouse_y = 688, 42

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
            f"--posy={position_y}", '--title=yad-calendar', "--borders=0"
        ])
    except subprocess.CalledProcessError as e:
        subprocess.CalledProcessError("Could not open yad-calendar: " + str(e))


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--popup",
                        action="store_true",
                        help="Show yad-calendar as a popup")
    args = parser.parse_args()

    dependencies = ["swaymsg", "yad"]
    try:
        check_dependencies(dependencies)
    except SystemExit as e:
        print(e)
        sys.exit(1)

    if args.popup:
        try:
            show_popup()
        except subprocess.CalledProcessError as e:
            print(e)
            sys.exit(1)
    else:
        global ICON
        print(ICON)


if __name__ == "__main__":
    main()
