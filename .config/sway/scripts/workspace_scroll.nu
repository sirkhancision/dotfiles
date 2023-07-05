#!/usr/bin/env nu

def main [] {
  let workspaces = (get_workspaces)
  let current = (get_current_workspace | into int)
  let next = (get_next_workspace $workspaces $current | into int)
  (goto_next_workspace $next)
}

def get_workspaces [] {
  swaymsg -t get_workspaces | from json | each { |x| $x.name | into int }
}

def get_current_workspace [] {
  swaymsg -t get_workspaces | from json | where focused == true | get name.0
}

def get_next_workspace [
  workspaces
  current: int
  ] {
  if ($current == ($workspaces | last)) {
    ($workspaces | first)
  } else {
    let next_index = ($workspaces | enumerate | where item > $current | get index.0)

    ($next_index + 1)
  }
}

def goto_next_workspace [next: int] {
  swaymsg workspace $next
}
