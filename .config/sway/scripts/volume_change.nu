#!/usr/bin/env nu

export def main [change: string] {
  if $change not-in ["increase", "decrease"] {
    let span = (metadata $change).span
    error make {
      msg: "invalid operation parameter",
      label: {
        text: "has to be either increase or decrease",
        start: $span.start,
        end: $span.end
      }
    }
  }

  change_volume (get_target_volume (get_volume) ($change == "increase"))
}

def get_volume []: nothing -> int {
  ^pactl get-sink-volume @DEFAULT_SINK@
    | parse -r '(\d+)%'
    | get capture0.0
    | into int
}

def get_target_volume [
  volume: int
  do_increase: bool
  ]: nothing -> int {
  let values = [0, 8, 17, 25, 33, 39, 50, 58, 67, 75, 83, 90, 100]

  if ($volume in $values) {
    if $do_increase {
      $values | skip until { |x| $x > $volume } | first
    } else {
      $values | each while { |x| if $x < $volume { $x } } | last
    }
  } else {
    let closest_value_index = $values
      | par-each { |x| ($x - $volume) | math abs }
      | enumerate
      | where item == ($in.item | math min)
      | get index.0

    $values
      | enumerate
      | where index == (if $do_increase {
          $closest_value_index + 1
        } else {
          $closest_value_index - 1
        })
      | get item.0
  }
}

def change_volume [target_volume: int] {
  if ($target_volume >= 0) and ($target_volume <= 100) {
    ^pactl set-sink-volume @DEFAULT_SINK@ $"($target_volume)%"
  }
}
