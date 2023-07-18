#!/usr/bin/env nu

def main [target: int] {
  let workspaces = (^swaymsg -t get_workspaces
    | from json
    | par-each { |x| $x.name | into int })

  ^swaymsg workspace (get_workspace $workspaces $target | into int)
}

def get_workspace [
  workspaces
  target: int
  ] {
  $workspaces
    | enumerate
    | where index == ($target - 1)
    | get item.0
}
