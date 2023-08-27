export def xqr [query_term: string]: nothing -> record<> {
  let query = ^xq $query_term
  let query_table = $query | parse -r 'pkgver: (?<pkgver>\S+)\nshort_desc: (?<short_desc>.+)\n(?:alternatives:\n(?<alternatives>(?:\s+\S+\n)*))?architecture: (?<architecture>\S+)\n(?:build-options: (?<build_options>.+)\n)?(?:conflicts:\n(?<conflicts>(?:\s+\S+\n)*))?(?:changelog: (?<changelog>\S+)\n)?(?:conf_files:\n(?<conf_files>(?:\s+\S+\n)*))?filename-sha256: (?<filename_sha256>\S+)\nfilename-size: (?<filename_size>\S+)\nhomepage: (?<homepage>\S+)\ninstalled_size: (?<installed_size>\S+)\nlicense: (?<license>.+)\nmaintainer: (?<maintainer>.+)\npkgname: (?<pkgname>\S+)\n(?:replaces:\n(?<replaces>(?:\s+\S+\n)*))?(?:preserve: (?<preserve>\S+)\n)?repository: (?<repository>\S+)\n(?:run_depends:\n(?<run_depends>(?:\s+\S+\n)*))?(?:shlib-provides:\n(?<shlib_provides>(?:\s+\S+\n)*))?(?:shlib-requires:\n(?<shlib_requires>(?:\s+\S+\n)*))?source-revisions: (?<source_revisions>\S+)\n(?:depends:\n(?<depends>(?:\s+\S+\n?)*))?(?:required-by:\n(?<required_by>(?:\s+\S+(?:\n)?)*))?'

  $query_table
    | (split_alternatives $in)
    | (spaces_to_rows $in build_options)
    | (lines_to_rows $in conflicts)
    | (lines_to_rows $in conf_files)
    | (split_licenses $in)
    | (lines_to_rows $in replaces)
    | (lines_to_rows $in run_depends)
    | (lines_to_rows $in shlib_provides)
    | (lines_to_rows $in shlib_requires)
    | (lines_to_rows $in depends)
    | (lines_to_rows $in required_by)
    | into record
}

def split_licenses [table: table] {
  $table | upsert license ($in | get license | str trim | split row ', ')
}

def split_alternatives [table: table] {
  let alternatives = $table | get alternatives | into string | lines
    | parse -r '\s{2}(\S+):$' | values | flatten

  if ($alternatives | is-empty) {
    $table | reject alternatives
  } else {
    $table | upsert alternatives $alternatives
  }
}

def spaces_to_rows [
  table: table
  column: string
] {
  let rows = $table | get $column | str trim | split row -r '\s+'

  if ($rows | is-empty) or ($rows | split words | is-empty) {
    $table | reject $column
  } else {
    $table | upsert $column $rows
  }
}

def lines_to_rows [
  table: table
  column: string
  ] {
  let rows = $in | get $column | into string | lines
    | par-each { |line| $line | str trim }

  if ($rows | is-empty) {
    $table | reject $column
  } else {
    $table | upsert $column $rows
  }
}
