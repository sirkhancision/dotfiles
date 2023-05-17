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
        for dep in missing_deps:
            print(dep)
        sys.exit(1)


def go_to_workspace(target_workspace):
    """
    Go to the specified workspace
    """
    # gets the existing workspaces in json format
    workspaces_json = json.loads(
        subprocess.check_output(["i3-msg", "-t", "get_workspaces"]).decode("utf-8")
    )

    # gets the workspaces' names
    workspaces = [workspace["name"] for workspace in workspaces_json]

    if target_workspace >= 1 and target_workspace <= len(workspaces):
        subprocess.run(["i3-msg", "workspace", str(target_workspace)])
    else:
        print(f"No active workspace found at position {target_workspace}")
        sys.exit(1)


def main():
    """
    Scrolls through existing workspaces in i3wm, wrapping to the first one after the last
    """
    dependencies = ["i3-msg", "jq"]

    check_dependencies(dependencies)

    # workspace that you want to go to
    target_workspace = int(sys.argv[1])

    go_to_workspace(target_workspace)


if __name__ == "__main__":
    main()
