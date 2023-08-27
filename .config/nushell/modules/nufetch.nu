export def main [] {
  (sys
    | get host
    | reject sessions
    | reject boot_time)
  | merge (sys
    | get cpu
    | select 0
    | drop column 4
    | reject name
    | rename cpu
    | into record)
  | merge (sys
    | get mem
    | select total
    | rename mem)
}
