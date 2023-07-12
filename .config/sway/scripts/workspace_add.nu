#!/usr/bin/env nu

def main [] {
  let workspaces = (^swaymsg -t get_workspaces
  | from json
  | par-each { |x| $x.name | into int})
  let available = (get_available_workspace $workspaces)

  ^swaymsg workspace $available
}

def get_available_workspace [workspaces] {
  let available = ($workspaces
    | enumerate
    | par-each {|x|
      if $x.item != ($x.index + 1) { ($x.index + 1) }
    })

  if ($available | is-empty) {
    ($workspaces | length) + 1
  } else {
    $available
  }
}
