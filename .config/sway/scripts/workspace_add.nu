#!/usr/bin/env nu

def main [] {
  let workspaces = ^swaymsg -t get_workspaces
  | from json
  | par-each { |workspace| $workspace.name | into int }

  ^swaymsg workspace (get_available_workspace $workspaces)
}

def get_available_workspace [workspaces: list<int>]: nothing -> int {
  let available_ws = $workspaces
    | enumerate
    | each { |x| if $x.item != ($x.index + 1) { ($x.index + 1) } }

  if ($available_ws | is-empty) {
    # if there are no available workspaces
    ($workspaces | length) + 1
  } else {
      # if there are available workspaces
      $available_ws | first
  }
}
