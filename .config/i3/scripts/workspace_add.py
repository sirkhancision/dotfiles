#!/usr/bin/env python3

import json
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


def add_workspace():
    """
    Add a new workspace to i3wm at the first empty position
    """
    workspaces_json = json.loads(
        subprocess.check_output(["i3-msg", "-t",
                                 "get_workspaces"]).decode("utf-8"))

    occupied_workspaces = {
        int(workspace["name"])
        for workspace in workspaces_json
    }

    num_workspaces = len(workspaces_json)

    available_positions = set(range(1,
                                    num_workspaces + 2)) - occupied_workspaces
    new_workspace = min(available_positions)

    subprocess.run(["i3-msg", "workspace", str(new_workspace)])


def main():
    """
    Adds a new workspace to i3wm, at the first empty position
    """
    dependencies = ["i3-msg", "jq"]

    try:
        check_dependencies(dependencies)
    except SystemExit as e:
        print(e)
        sys.exit(1)

    add_workspace()


if __name__ == "__main__":
    main()
