def "nu-complete gi" [] {
  get_command_list
}

export def gi [...parameters: string@"nu-complete gi"] {
  match $parameters {
    "list" => { get_command_list }
    _ => { get_ignore_file ($parameters | split words) }
  }
}

def get_command_list [] {
  http get https://www.gitignore.io/api/list | lines | split row ','
}

def get_ignore_file [types: list<string>] {
  http get $"https://www.gitignore.io/api/($types | str join ',')"
}
