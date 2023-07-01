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


def go_to_next_workspace():
    """
    Switch to the workspace after the current one
    """
    workspaces_json = json.loads(
        subprocess.check_output(["swaymsg", "-t",
                                 "get_workspaces"]).decode("utf-8"))

    current_workspace = next(
        (workspace["name"]
         for workspace in workspaces_json if workspace["focused"]), None)

    if current_workspace is not None:
        workspaces = [workspace["name"] for workspace in workspaces_json]
        index = workspaces.index(current_workspace)
        next_index = (index + 1) % len(workspaces)
        next_workspace = workspaces[next_index]
    else:
        next_workspace = workspaces_json[0]["name"]

    subprocess.run(["swaymsg", "workspace", next_workspace])


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

    go_to_next_workspace()


if __name__ == "__main__":
    main()
