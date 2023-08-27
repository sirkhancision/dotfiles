export def xrst [search_term: string]: nothing -> table<> {
  ^xrs $search_term
  | parse -r '(?<installed>\[[-*]\])\s+(?<package>\S+)-(?<version>[\S+]+_\d+)\s+(?<description>.+)'
  | move version --after description
  | upsert installed {
    |x| if $x.installed == "[*]" {
      $"(ansi green_bold)yes"
    } else {
      $"(ansi red_bold)no"
    }
  }
}
