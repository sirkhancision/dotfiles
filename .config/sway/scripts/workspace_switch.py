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
    workspaces_json = json.loads(
        subprocess.check_output(["swaymsg", "-t",
                                 "get_workspaces"]).decode("utf-8"))

    workspace_dict = {
        index: workspace["name"]
        for index, workspace in enumerate(workspaces_json, start=1)
    }

    if target_workspace in workspace_dict:
        subprocess.run(
            ["swaymsg", "workspace", workspace_dict[target_workspace]])
    else:
        raise ValueError(
            f"No active workspace found at position {target_workspace}")


def main():
    """
    Scrolls through existing workspaces in Sway, wrapping to the
    first one after the last
    """
    dependencies = ["swaymsg", "jq"]

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
