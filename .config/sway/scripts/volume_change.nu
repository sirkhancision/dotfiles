#!/usr/bin/env nu

export def main [change: string] {
  let do_increase = $change == "increase"
  let volume = (get_volume | into int)
  let target_volume = (get_target_volume $volume $change $do_increase | into int)
  (change_volume $target_volume)
}

def get_volume [] {
  pactl get-sink-volume @DEFAULT_SINK@ | parse -r '(\d+)%' | get capture0.0
}

def get_target_volume [
  volume: int
  change: string
  do_increase: bool
  ] {
  let values = [0 8 17 25 33 39 50 58 67 75 83 90 100]
  let min_sort_list = ($values | each { |x| ($x - $volume) | math abs })
  let closest_value_index = ($min_sort_list | enumerate | where item == ($min_sort_list | math min) | get index.0 | into int)

  if $do_increase {
    ($values | enumerate | where index == ($closest_value_index + 1) | get item.0)
  } else {
    ($values | enumerate | where index == ($closest_value_index - 1) | get item.0)
  }
}

def change_volume [target_volume: int] {
  if ($target_volume > 0) and ($target_volume < 100) {
    pactl set-sink-volume @DEFAULT_SINK@ $"($target_volume)%"
  }
}
