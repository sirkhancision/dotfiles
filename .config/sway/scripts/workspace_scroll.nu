#!/usr/bin/env nu

def main [] {
  let workspaces_table = (^swaymsg -t get_workspaces | from json)
  let workspaces_list = ($workspaces_table
    | par-each { |x| $x.name | into int })

  let current = ($workspaces_table
    | where focused == true
    | get name.0
    | into int)
  let next = (get_next_workspace $workspaces_list $current | into int)

  ^swaymsg workspace $next
}

def get_next_workspace [
  workspaces
  current: int
  ] {
  if $current == ($workspaces | last) {
    $workspaces | first
  } else {
    $workspaces
      | enumerate
      | where item > $current
      | get item.0
  }
}
