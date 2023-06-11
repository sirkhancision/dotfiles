#!/usr/bin/env python3

import re
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


def parse_argument():
    """
    Gets the type of change desired (increasing or decreasing)
    """
    valid_operations = ["increase", "decrease"]

    if len(sys.argv) < 2 or sys.argv[1] not in valid_operations:
        raise ValueError("Invalid operation: either 'increase' or 'decrease'"
                         "has to be passed")

    return sys.argv[1]


def get_current_volume():
    """
    Gets the current volume percentage from the system
    """
    try:
        sink_volume = subprocess.run(
            ["pactl", "get-sink-volume", "@DEFAULT_SINK@"],
            capture_output=True,
            text=True).stdout
    except subprocess.CalledProcessError:
        raise subprocess.CalledProcessError("Failed to get system's volume")

    volume = int(re.search(r"(\d+)%", sink_volume).group(1))
    return volume


def get_target_volume(volume, change_type):
    """
    Calculates the target value for the system's volume to be changed into
    """
    # each of these values (except from 0) are from ceil(100/12):
    # because volume will have 12 possible values, I'm dividing the maximum
    # possible value for the volume (100) by the possible amount of values,
    # and rounding them up to an integer
    volume_values = [0, 9, 17, 25, 34, 42, 50, 59, 67, 75, 84, 92, 100]

    # the addition or subtraction is by 9 because 100/12 is approximately
    # 8.3, which rounds up to 9
    if change_type == "increase":
        changed_volume = volume + 9
    else:
        changed_volume = volume - 9

    # get the value from volume_values that is the closest to
    # changed_volume, and change the volume to that value
    target_volume = min(volume_values, key=lambda x: abs(x - changed_volume))
    return target_volume


def change_volume(target_volume):
    """
    Changes the system's volume to the target volume
    """
    try:
        subprocess.run([
            "pactl", "set-sink-volume", "@DEFAULT_SINK@", f"{target_volume}%"
        ])
    except subprocess.CalledProcessError:
        raise subprocess.CalledProcessError(
            "Failed to change the system's volume")


def main():
    """
    Change the system's volume in 12 possible steps, to fit in the visuals of
    a hexagon
    """
    dependencies = ["pactl"]
    try:
        check_dependencies(dependencies)
    except SystemExit as e:
        print(e)
        sys.exit(1)

    try:
        change_type = parse_argument()
    except ValueError as e:
        print(e)
        sys.exit(1)

    try:
        volume = get_current_volume()
    except subprocess.CalledProcessError as e:
        print(e)
        sys.exit(1)

    target_volume = get_target_volume(volume, change_type)

    try:
        change_volume(target_volume)
    except subprocess.CalledProcessError as e:
        print(e)
        sys.exit(1)


if __name__ == "__main__":
    main()
