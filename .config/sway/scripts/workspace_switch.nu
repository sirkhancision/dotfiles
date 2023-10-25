#!/usr/bin/env nu

def main [target: int] {
  let workspaces = ^swaymsg -t get_workspaces
    | from json
    | par-each { |x| $x.name | into int }

  ^swaymsg workspace (get_workspace $workspaces $target)
}

def get_workspace [
  workspaces: list<int>
  target: int
  ]: nothing -> int {
  $workspaces
    | enumerate
    | where index == ($target - 1)
    | get item.0
}
