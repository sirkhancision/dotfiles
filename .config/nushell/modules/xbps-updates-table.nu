#!/usr/bin/env nu

export def main [] {
  cd ~/void-packages
  git fetch upstream master
  git pull upstream master

  let updates = (xbps-checkvers -If "%n %r %s"
    | parse -r '(?<package>\S+)\s+(?<current>\S+)\s+(?<update>\S+)')

  if ($updates | is-empty) { "" } else { $updates }
}
