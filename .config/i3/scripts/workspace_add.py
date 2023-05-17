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


def add_workspace():
    """
    Add a new workspace to i3wm at the first empty position
    """
    workspaces_json = json.loads(
        subprocess.check_output(["i3-msg", "-t", "get_workspaces"]).decode("utf-8")
    )

    workspaces = [workspace["name"] for workspace in workspaces_json]

    num_workspaces = len(workspaces)

    new_workspace = num_workspaces + 1

    for index, workspace in enumerate(workspaces, start=1):
        if workspace != str(index):
            new_workspace = index

    subprocess.run(["i3-msg", "workspace", str(new_workspace)])


def main():
    """
    Adds a new workspace to i3wm, at the first empty position
    """
    dependencies = ["i3-msg", "jq"]

    check_dependencies(dependencies)

    add_workspace()


if __name__ == "__main__":
    main()
