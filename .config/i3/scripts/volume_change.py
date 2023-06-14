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
    except subprocess.CalledProcessError as e:
        raise subprocess.CalledProcessError("Failed to get system's volume: " +
                                            str(e))

    volume = int(re.search(r"(\d+)%", sink_volume).group(1))
    return volume


def get_target_volume(volume, change_type):
    """
    Calculates the target value for the system's volume to be changed into
    """
    volume_values = [0, 9, 17, 25, 34, 42, 50, 59, 67, 75, 84, 92, 100]
    num_values = len(volume_values)

    current_index = min(range(num_values),
                        key=lambda i: abs(volume_values[i] - volume))

    target_index = (current_index +
                    1 if change_type == "increase" else current_index - 1)

    target_index = max(0, min(target_index, num_values - 1))

    target_volume = volume_values[target_index]

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
        change_type = parse_argument()
        volume = get_current_volume()
        target_volume = get_target_volume(volume, change_type)
        change_volume(target_volume)
    except (SystemExit, ValueError, subprocess.CalledProcessError) as e:
        print(e)
        sys.exit(1)


if __name__ == "__main__":
    main()
