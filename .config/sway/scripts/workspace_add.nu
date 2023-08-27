#!/usr/bin/env nu

def main [] {
  let workspaces = ^swaymsg -t get_workspaces
  | from json
  | par-each { |x| $x.name | into int }

  ^swaymsg workspace (get_available_workspace $workspaces)
}

def get_available_workspace [workspaces: list<int>]: nothing -> int {
  let available = $workspaces
    | enumerate
    | each { |x| if $x.item != ($x.index + 1) { ($x.index + 1) } }

  if ($available | is-empty) {
    ($workspaces | length) + 1
  } else {
    if ($available | length) > 1 {
      $available | first
    } else {
      $available
    }
  }
}
