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


def go_to_workspace(target_workspace):
    """
    Go to the specified workspace
    """
    # gets the existing workspaces in json format
    workspaces_json = json.loads(
        subprocess.check_output(["i3-msg", "-t",
                                 "get_workspaces"]).decode("utf-8"))

    # gets the workspaces' names
    workspaces = [workspace["name"] for workspace in workspaces_json]

    if target_workspace >= 1 and target_workspace <= len(workspaces):
        for index, workspace in enumerate(workspaces, start=1):
            if index == target_workspace:
                subprocess.run(["i3-msg", "workspace", workspace])
                return

    raise ValueError(
        f"No active workspace found at position {target_workspace}")


def main():
    """
    Scrolls through existing workspaces in i3wm, wrapping to the
    first one after the last
    """
    dependencies = ["i3-msg", "jq"]

    try:
        check_dependencies(dependencies)
    except SystemExit as e:
        print(e)
        sys.exit(1)

    # workspace that you want to go to
    target_workspace = int(sys.argv[1])

    try:
        go_to_workspace(target_workspace)
    except ValueError as e:
        print(e)
        sys.exit(1)


if __name__ == "__main__":
    main()
