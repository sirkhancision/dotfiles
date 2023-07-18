def "nu-complete archive" [] {
  [
    "7z"
    "bz2"
    "gz"
    "jar"
    "lzma"
    "lzo"
    "rar"
    "tar"
    "tar.Z"
    "tar.bz2"
    "tar.gz"
    "tar.xz"
    "tbz"
    "tbz2"
    "tgz"
    "txz"
    "xz"
    "zip"
    "zst"
  ]
  }

# Function to create archives with different extensions.
export def archive [
  extension: string@"nu-complete archive"
  name: string
  ...files: string
  ] {
  let handlers = [ [extension command];
                   ['7z'                        '7z a']
                   ['bz2'                 'bzip2 -vcf']
                   ['gz'                   'gzip -vcf']
                   ['jar'                    'jar cvf']
                   ['lzma'              'lzma -vc -T0']
                   ['lzo'                   'lzop -vc']
                   ['rar'                      'rar a']
                   ['tar'                   'tar -cvf']
                   ['tar\.Z'               'tar -cvZf']
                   ['tar\.bz2|tbz|tbz2'    'tar -cvjf']
                   ['tar\.gz|tgz'          'tar -cvzf']
                   ['tar\.xz|txz'           'tar -cvf']
                   ['xz'                  'xz -vc -T0']
                   ['zip'                  'zip -rull']
                   ['zst'                'zstd -c -T0']
                 ]
  let maybe_handler = ($handlers | where $extension =~ $it.extension)

  if ($maybe_handler | is-empty) {
    let span = (metadata $extension).span
    error make {
      msg: "unsupported file extension"
      label: {
        text: "the file extension provided is not supported",
        start: $span.start,
        end: $span.end
      }
    }
  } else {
    let handler = ($maybe_handler | first)
    let extensions_with_name_prefix = [
      "7z"
      "rar"
      "jar"
      "tar.bz2"
      "tbz"
      "tar.gz"
      "tgz"
      "tar.lzma"
      "tlz"
      "tar.xz"
      "txz"
      "tar.Z"
      "tZ"
      "zip"
    ]

    if $extension in $extensions_with_name_prefix {
      nu -c $"^($handler.command) ($name).($extension) ($files | str join ' ')"
    } else {
      nu -c $"^($handler.command) ($files | str join ' ') | save ($name).($extension)"
    }
  }
}
