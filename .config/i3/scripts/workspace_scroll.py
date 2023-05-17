#!/usr/bin/env python3.11

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
        print("The following dependencies are missing:")
        print("\n".join(missing_deps))
        sys.exit(1)


def get_next_workspace(workspaces, current_workspace):
    """
    Get the workspace after the current one
    """
    # if at the last workspace, wrap around to the first one
    if current_workspace == workspaces[-1]:
        return workspaces[0]
    # otherwise just go next
    else:
        index = workspaces.index(current_workspace)
        return workspaces[index + 1]


def go_to_next_workspace():
    """
    Switch to the workspace after the current one
    """
    # gets the existing workspaces in json format
    workspaces_json = json.loads(
        subprocess.check_output(["i3-msg", "-t", "get_workspaces"]).decode("utf-8")
    )

    # gets the workspaces' names
    workspaces = [workspace["name"] for workspace in workspaces_json]

    current_workspace = next(
        (workspace["name"] for workspace in workspaces_json if workspace["focused"]),
        None,
    )

    next_workspace = get_next_workspace(workspaces, current_workspace)

    subprocess.run(["i3-msg", "workspace", next_workspace])


def main():
    """
    Scrolls through existing workspaces in i3wm, wrapping to the first one after the last
    """
    dependencies = ["i3-msg", "jq"]

    check_dependencies(dependencies)

    go_to_next_workspace()


if __name__ == "__main__":
    main()
