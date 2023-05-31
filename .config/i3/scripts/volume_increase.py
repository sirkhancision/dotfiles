#!/usr/bin/env python3

from shutil import which
import re
import subprocess
import sys


def check_dependencies(dependencies):
    """
    Check if the required programs are installed
    """
    missing_deps = [cmd for cmd in dependencies if which(cmd) is None]
    if missing_deps:
        print("The following dependencies are missing:")
        print("\n".join(missing_deps))
        sys.exit(1)


def main():
    dependencies = ["pactl"]
    check_dependencies(dependencies)

    increase_percentage = sys.argv[1]

    # get current volume
    sink_volume = subprocess.run(
        ["pactl", "get-sink-volume", "@DEFAULT_SINK@"], capture_output=True, text=True
    ).stdout
    volume = int(re.search(r"(\d+)%", sink_volume).group(1))

    # increase volume if not at 100%
    if volume < 100:
        subprocess.run(
            ["pactl", "set-sink-volume", "@DEFAULT_SINK@", f"+{increase_percentage}%"]
        )
    elif volume != 100:
        subprocess.run(["pactl", "set-sink-volume", "@DEFAULT_SINK@", "100%"])


if __name__ == "__main__":
    main()
