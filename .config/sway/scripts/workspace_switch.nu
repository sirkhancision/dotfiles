#!/usr/bin/env nu

def main [target: int] {
  let workspaces_table = (^swaymsg -t get_workspaces | from json)
  let workspaces_list = ($workspaces_table
    | par-each { |x| $x.name | into int })

  let workspace = (get_workspace $workspaces_list $target | into int)

  ^swaymsg workspace $workspace
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
