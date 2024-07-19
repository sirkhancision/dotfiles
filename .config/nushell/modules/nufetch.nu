export def main [] {
  (sys host | reject boot_time)
  | merge (sys cpu
    | select brand
    | get 0
    | rename cpu)
  | merge (sys mem
    | select total
    | rename mem)
}
