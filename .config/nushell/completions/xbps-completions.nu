########
# XBPS #
########

def "nu-complete xbps-packages" [] {
  open /var/db/xbps/pkgdb-0.38.plist
    | from xml
    | get content.content
    | flatten
    | where tag == key
    | get content
    | flatten
    | get content
    | filter { |x| $x =~ '^[0-9A-Za-z]' }
}

def "nu-complete void-packages" [] {
  ^ls ~/void-packages/srcpkgs | lines
}

export extern "xbps-alternatives" [
  --config(-C): path          # Path to confdir (xbps.d)
  --debug(-d)               # Debug mode shown to stderr
  --group(-g): string   # Group of alternatives to match
  --help(-h)                          # Print usage help
  --rootdir(-r): path             # Full path to rootdir
  --verbose(-v)                       # Verbose messages
  --version(-V)                      # Show XBPS version
  --list(-l): string # List all alternatives or from PKG
  --set(-s): string           # Set alternatives for PKG
]

export extern "xbps-checkvers" [
  ...packages: string@"nu-complete void-packages" # Extra packages to process with the outdated ones (only processed if missing)
  --help(-h)                                                                           # Show this helpful help-message for help
  --config(-C): path                                                                                        # Set path to xbps.d
  --distdir(-D): path                                                              # Set (or override) the path to void-packages
  --debug(-d)                                                                                    # Enable debug output to stderr
  --removed(-e)                                                             # List packages present in repos, but not in distdir
  --format(-f): string                                                                                           # Output format
  --installed(-I)                                 # Check for outdated packages in rootdir, rather than in the XBPS repositories
  --ignore-conf-repos(-i)                                                                # Ignore repositories defined in xbps.d
  --manual(-m)                                                                                       # Only process listed files
  --repository(-R): string                                                    # Append repository to the head of repository list
  --rootdir(-r): path                                                                                       # Set root directory
  --show-all(-s)                                                     # List all packages, in the format 'pkgname repover srcver'
]

export extern "xbps-create" [
  --architecture(-A): string                                          # Package architecture (e.g: noarch, i686, etc)
  --built-with(-B): string                                                # Package builder string (e.g: xbps-src-30)
  --conflicts(-C): string                               # Conflicts (blank separated list, e.g: 'foo>=2.0 blah<=2.0')
  --changelog(-c): string                                                                             # Changelog URL
  --dependencies(-D): string                        # Dependencies (blank separated list, e.g: 'foo>=1.0_1 blah<2.1')
  --config-files(-F): path       # Configuration files (blank separated list, e.g '/etc/foo.conf /etc/foo-blah.conf')
  --homepage(-H): string                                                                                   # Homepage
  --help(-h)                                                                                              # Show help
  --license(-l): string                                                                                     # License
  --mutable-files(-M): path            # Mutable files list (blank separated list, e.g: '/usr/lib/foo /usr/bin/blah')
  --maintainer(-m): string                                                                               # Maintainer
  --pkgver(-n): string                                                 # Package name/version tuple (e.g 'foo-1.0_1')
  --provides(-P): string                                             # blank separated list, e.g: 'foo-9999 blah-1.0'
  --preserve(-p)                                                                    # Enable package preserve boolean
  --quiet(-q)                                                                                         # Work silently
  --replaces(-R): string                                  # Replaces (blank separated list, e.g: 'foo>=1.0 blah<2.0')
  --reverts(-r): string                                          # Reverts (blank separated list, e.g: '1.0_1 2.0_3')
  --long-desc(-S): string                                                       # Long description (80 cols per line)
  --desc(-s): string                                                          # Short description (max 80 characters)
  --tags(-t): string                                               # A list of tags/categories (blank separated list)
  --version(-V)                                                                         # Prints XBPS release version
  --alternatives                                                   # List of available alternatives this pkg provides
  --build-options: string                                                      # A string with the used build options
  --compression: string                              # Compression format: none, gzip, bzip2, lz4, xz, zstd (default)
  --shlib-provides: string  # List of provided shared libraries (blank separated list, e.g 'libfoo.so.1 libblah.so.2)
  --shlib-requires: string # List of required shared libraries (blank separated list, e.g 'libfoo.so.1 libblah.so.2')
]

export extern "xbps-dgraph" [
  ...packages: string@"nu-complete xbps-packages"                           # Name of the packages to operate on
  --config(-C): path                                                                  # Path to confdir (xbps.d)
  --graph-config(-c): path                                                # Path to the graph configuration file
  --debug(-d)                                                                       # Debug mode shown to stderr
  --help(-h)                                                                                  # Print help usage
  --memory-sync(-M) # Remote repository data is fetched and stored in memory, ignoring on-disk repodata archives
  --roodir(-r): path                                                                      # Full path to rootdir
  --repository(-R)             # Enable repository mode. This mode explicitly looks for packages in repositories
  --gen-config(-g)                                                               # Generate a configuration file
  --fulldeptree(-f)                                                                # Generate a dependency graph
  --metadata(-m)                                                      # Generate a metadata graph (default mode)
]

export extern "xbps-digest" [
  files?: path # If not set, reads from stdin
  -h # Show usage()
  -m: string # Selects the digest mode, sha256 (default)
  -V # Prints the xbps release version
]

export extern "xbps-fbulk" [
  ...packages: string@"nu-complete void-packages" # Name of the packages to operate on
  -a: string                                     # Set a different target architecture
  -j: int                     # Set number of parallel builds running at the same time
  -l: path                                                     # Set the log directory
  --debug(-d)                                # Enables extra debugging shown to stderr
  --help(-h)                                                   # Show the help message
  --verbose(-v)                                             # Enables verbose messages
  --version(-V)                                         # Show the version information
]

export extern "xbps-fetch" [
  -d # Enable debug messages to stderr
  -h                    # Show usage()
  -o: string  # Rename downloaded file
  -s  # Output sha256sums of the files
  -v           # Enable verbose output
  -V # Prints the xbps release version
]

export extern "xbps-install" [
  ...packages: string@"nu-complete xbps-packages"                           # Name of the packages to operate on
  --automatic(-A)                                                              # Set automatic installation mode
  --config(-C): path                                                                  # Path to confdir (xbps.d)
  --cachedir(-c): path                                                                        # Path to cachedir
  --debug(-d): string                                                               # Debug mode shown to stderr
  --download-only(-D)                                      # Download packages and check integrity, nothing else
  --force(-f)                # Force package re-installation. If specified twice, all files will be overwritten.
  --help(-h)                                                                                  # Print help usage
  --ignore-conf-repos(-i)                                                # Ignore repositories defined in xbps.d
  --ignore-file-conflicts(-I)                                                   # Ignore detected file conflicts
  --unpack-only(-U)                                      # Unpack packages in transaction, do not configure them
  --memory-sync(-M) # Remote repository data is fetched and stored in memory, ignoring on-disk repodata archives
  --dry-run(-n)                                                                                   # Dry-run mode
  --repository(-R): string # Add repository to the top of the list. This option can be specified multiple times.
  --rootdir(-r): string                                                                   # Full path to rootdir
  --reproducible                                                             # Enable reproducible mode in pkgdb
  --sync(-S)                                                                      # Sync remote repository index
  --update(-u)                                                                        # Update target package(s)
  --verbose(-v)                                                                               # Verbose messages
  --yes(-y)                                                                        # Assume yes to all questions
  --version(-V)                                                                              # Show XBPS version
]

export extern "xbps-pkgdb" [
  ...packages: string@"nu-complete xbps-packages" # Name of the packages to operate on
  --all(-a)                                                     # Process all packages
  --config(-C): path                                        # Path to confdir (xbps.d)
  --debug(-d)                                             # Debug mode shown to stderr
  --help(-h)                                                        # Print usage help
  --mode(-m)         # Change PKGNAME to <auto|manual|hold|unhold|repolock|repounlock>
  --rootdir(-r): path                                           # Full path to rootdir
  --update(-u)                                     # Update pkgdb to the latest format
  --verbose(-v)                                                     # Verbose messages
  --version(-V)                                                    # Show XBPS version
]

export extern "xbps-query" [
  ...packages: string@"nu-complete xbps-packages"                                # Name of packages to operate on
  --config(-C): path                                                                   # Path to confdir (xbps.d)
  --cachedir(-c): path                                                                         # Path to cachedir
  --debug(-d)                                                                        # Debug mode shown to stderr
  --help(-h)                                                                                   # Print help usage
  --ignore-conf-repos(-i)                                                 # Ignore repositories defined in xbps.d
  --memory-sync(-M) # Remote repository data is fetched and stored in memory, ignoring on-disk repodata archives.
  --property(-p): string                                                            # Show properties for PKGNAME
  --repository(-R)             # Enable repository mode. This mode explicitly looks for packages in repositories.
  --regex                                                             # Use Extended Regular Expressions to match
  --fulldeptree                                                              # Full dependency tree for -x/--deps
  --rootdir(-r): path                                                                      # Full path to rootdir
  --version(-V)                                                                               # Show XBPS version
  --verbose(-v)                                                                                # Verbose messages
  --list-pkgs(-l)                                                                       # List installed packages
  --list-repos(-L)                                                                 # List registered repositories
  --list-hold-pkgs(-H)                                                              # List packages on hold state
  --list-repolock-pkgs                                                                 # List repolocked packages
  --list-manual-pkgs(-m)                                                     # List packages installed explicitly
  --list-orphans(-O)                                                                       # List package orphans
  --ownedby(-o): string                                    # Search for package files by matching STRING or REGEX
  --show(-S): string                                                    # Show information for PKG [default mode]
  --search(-s): string                                     # Search for packages by matching PKG, STRING or REGEX
  --cat: string                                                            # Print FILE from PKG binpkg to stdout
  --files(-f): string                                                                # Show package files for PKG
  --deps(-x): string                                                                  # Show dependencies for PKG
  --revdeps(-X): string                                                       # Show reverse dependencies for PKG
]

export extern "xbps-reconfigure" [
  ...packages: string@"nu-complete xbps-packages" # Name of the packages to operate on
  --all(-a)                                                     # Process all packages
  --config(-C): path                                        # Path to confdir (xbps.d)
  --debug(-d)                                             # Debug mode shown to stderr
  --force(-f)                                                  # Force reconfiguration
  --help(-h)                                                        # Print usage help
  --ignore(-i): string                                      # Ignore PKG with -a/--all
  --rootdir(-r): path                                           # Full path to rootdir
  --verbose(-v)                                                     # Verbose messages
  --version(-V)                                                    # Show XBPS version
]

export extern "xbps-remove" [
  ...packages: string@"nu-complete xbps-packages"         # Name of the packages to operate on
  --config(-C): path                                                # Path to confdir (xbps.d)
  --cachedir(-c): path                                                      # Path to cachedir
  --debug(-d)                                                     # Debug mode shown to stderr
  --force-revdeps(-F) # Force package removal even with revdeps or unresolved shared libraries
  --force(-f)                                                    # Force package files removal
  --help(-h)                                                                # Print help usage
  --dry-run(-n)                                                                 # Dry-run mode
  --clean-cache(-O)                                     # Remove obsolete packages in cachedir
  --remove-orphans(-o)                                                # Remove package orphans
  --recursive(-R)                                            # Recursively remove dependencies
  --rootdir(-r): path                                                   # Full path to rootdir
  --verbose(-v)                                                             # Verbose messages
  --yes(-y)                                                      # Assume yes to all questions
  --version(-V)                                                            # Show XBPS version
]
export extern "xbps-rindex" [
  --debug(-d)                                               # Debug mode shown to stderr
  --force(-f)                                # Force mode to overwrite entry in add mode
  --help(-h)                                                           # Show help usage
  --verbose(-v)                                                       # Verbose messages
  --version(-V)                                                      # Show XBPS version
  --hashcheck(-C)                        # Consider file hashes for cleaning up packages
  --compression: string # Compression format: none, gzip, bzip2, lz4, xz, zstd (default)
  --privkey: path                                  # Path to the private key for signing
  --signedby: string                             # Signature details, i.e 'name <email>'
  --add(-a): path                                   # Add package(s) to repository index
  --clean(-c): path                                             # Clean repository index
  --remove-obsoletes(-r): path               # Removes obsolete packages from repository
  --sign(-s): path                            # Initialize repository metadata signature
  --sign-pkg(-S): path                                     # Sign binary package archive
]


##########
# XTOOLS #
##########

export extern "xi" [
  ...packages: string@"nu-complete void-packages" # Name of the packages to install
]

export extern "xq" [
  ...packages: string@"nu-complete void-packages" # Name of the packages to install
  -R # Query remote repos
]

############################
# XBPS-SRC (void-packages) #
############################

def "nu-complete xbps-src-cmds" [] {
  [
    { value: "binary-bootstrap", description: "Install boostrap packages from host repositories into <masterdir>" },
    { value: "bootstrap", description: "Build and install from source the boostrap packages into <masterdir>" },
    { value: "bootstrap-update", description: "Updates bootstrap packages with latest versions available from registered repositories in the XBPS configuration file" },
    { value: "consistency-check", description: "Runs a consistency check on all packages" },
    { value: "chroot", description: "Enter to the chroot in <masterdir>" },
    { value: "clean-repocache", description: "Removes obsolete packages from <hostdir>/repocache" },
    { value: "fetch", description: "Download package source distribution file(s)" },
    { value: "extract", description: "Extract package source distribution file(s) into the build directory" },
    { value: "patch", description: "Patch the package sources and perform other operations required to prepare a package for configuring and building" },
    { value: "configure", description: "Configure a package (fetch + extract + patch + configure)" },
    { value: "build", description: "Build package source (fetch + extract + patch + configure + build)" },
    { value: "check", description: "Run the package check(s) after building the package source" },
    { value: "install", description: "Install target package into <destdir> but not building the binary package and not removing build directory for inspection purposes" },
    { value: "pkg", description: "Build binary package for <pkgname> and all required dependencies" },
    { value: "clean", description: "Removes auto dependencies, cleans up <masterdir>/builddir and <masterdir>/destdir" },
    { value: "list", description: "Lists installed packages in <masterdir>" },
    { value: "remove", description: "Remove target package from <destdir>" },
    { value: "remove-autodeps", description: "Removes all package dependencies that were installed automatically" },
    { value: "purge-distfiles", description: "Removes all obsolete distfiles in <hostdir>/sources" },
    { value: "show", description: "Show information for the specified package" },
    { value: "show-avail", description: "Returns 0 if package can be built for the given architecture, any other error otherwise" },
    { value: "show-build-deps", description: "Show required build dependencies for <pkgname>" },
    { value: "show-deps", description: "Show required run-time dependencies for <pkgname>. Package must be installed into destdir" },
    { value: "show-files", description: "Show files installed by <pkgname>" },
    { value: "show-hostmakedepends", description: "Show required host build dependencies for <pkgname>" },
    { value: "show-makedepends", description: "Show required target build dependencies for <pkgname>" },
    { value: "show-options", description: "Show available build options by <pkgname>" },
    { value: "show-shlib-provides", description: "Show list of provided shlibs for <pkgname>" },
    { value: "show-shlib-requires", description: "Show list of required shlibs for <pkgname>" },
    { value: "show-var", description: "Prints the value of <var> if it's defined in xbps-src" },
    { value: "show-repo-updates", description: "Prints the list of outdated packages in XBPS repositories" },
    { value: "show-sys-updates", description: "Prints the list of outdated packages in your system" },
    { value: "show-local-updates", description: "Prints the list of outdated packages in your local repositories" },
    { value: "sort-dependencies", description: "Given a list of packages specified as additional arguments, a sorted dependency list will be returned to stdout" },
    { value: "update-bulk", description: "Rebuilds all packages in the system repositories that are outdated" },
    { value: "update-sys", description: "Rebuilds all packages in your system that are outdated and updates them" },
    { value: "update-local", description: "Rebuilds all packages in your local repositories that are outdated" },
    { value: "update-check", description: "Check upstream site of <pkgname> for new releases" },
    { value: "update-hash-cache", description: "Update the hash cache with existing source distfiles" },
    { value: "zap", description: "Removes a masterdir but preserving ccache, distcc and host directories" },
  ]
}

def "nu-complete xbps-src-archs" [] {
  [
  	"aarch64-musl"
  	"aarch64"
  	"armv5te-musl"
  	"armv5te"
  	"armv5tel-musl"
  	"armv5tel"
  	"armv6hf-musl"
  	"armv6hf"
  	"armv6l-musl"
  	"armv6l"
  	"armv7hf-musl"
  	"armv7hf"
  	"armv7l-musl"
  	"armv7l"
  	"i686-musl"
  	"i686"
  	"mips-musl"
  	"mipsel-musl"
  	"mipselhf-musl"
  	"mipshf-musl"
  	"ppc-musl"
  	"ppc"
  	"ppc64-musl"
  	"ppc64"
  	"ppc64le-musl"
  	"ppc64le"
  	"ppcle-musl"
  	"ppcle"
  	"x86_64-musl"
  	"x86_64"
  ]
}

export extern "./xbps-src" [
  cmd: string@"nu-complete xbps-src-cmds"
  -1                                                                      # If dependencies of target package are missing, fail instead of building them
  -a: string@"nu-complete xbps-src-archs"                                                               # Cross compile packages for this target machine
  -b                                                                          # Build packages even if marked as broken, nocross, or excluded with archs
  -c: path # If specified, etc/conf.<configuration> will be used as the primary config file name; etc/conf will only be attempted if that does not exist
  -C                                                # Do not remove build directory, automatic dependencies and package destdir after successful install
  -E                                       # If a binary package exists in a repository for the target package, do not try to build it, exit immediately
  -f                                                       # Force running the specified stage (configure/build/install/pkg) even if it ran successfully
  -G                                                                             # Enable XBPS_USE_GIT_REVS (see etc/defaults.conf for more information)
  -g                                                                                              # Enable building -dbg packages with debugging symbols
  -H: path                                                                         # Absolute path to a directory to be bind mounted at <masterdir>/host
  -h                                                                                                                                      # Usage output
  -I                                                                              # Ignore required dependencies, useful for extracting/fetching sources
  -i                                                                                                           # Make xbps-src internal errors non-fatal
  -j                                                                                       # Number of parallel build jobs to use when building packages
  -L                                                                                                                              # Disable ASCII colors
  -m: path                                                                                        # Absolute path to a directory to be used as masterdir
  -N                                                                                        # Disable use of remote repositories to resolve dependencies
  -o: string                                                                              # Enable or disable (prefixed with ~) package build options
  -p: string                                                                  # For show target, show specified variables in addition to default ones
  -Q                                                                                                                    # Enable running the check stage
  -K                                                                                                  # Enable running the check stage with longer tests
  -q                                                                         # Suppress informational output of xbps-src (build output is still printed)
  -r: path                                                                      # Use an alternative local repository to store generated binary packages
  -s                                                                                                                         # Make vsed warnings errors
  -t                                                                                       # Create a temporary masterdir to not pollute the current one
  -V                                                                                                                  # Print version of xbps, then exit
]

export extern "./xbps-src binary-bootstrap" [
  arch?: string@"nu-complete xbps-src-archs" # Target architecture to bootstrap to
]

export extern "./xbps-src build" [
  package: string@"nu-complete void-packages" # Name of package to operate on
]

export extern "./xbps-src check" [
  package: string@"nu-complete void-packages" # Name of package to operate on
]

export extern "./xbps-src clean" [
  package?: string@"nu-complete void-packages" # Name of package to operate on
]

export extern "./xbps-src configure" [
  package: string@"nu-complete void-packages" # Name of package to operate on
]

export extern "./xbps-src extract" [
  package: string@"nu-complete void-packages" # Name of package to operate on
]

export extern "./xbps-src fetch" [
  package: string@"nu-complete void-packages" # Name of package to operate on
]

export extern "./xbps-src install" [
  package: string@"nu-complete void-packages" # Name of package to operate on
]

export extern "./xbps-src patch" [
  package: string@"nu-complete void-packages" # Name of package to operate on
]

export extern "./xbps-src pkg" [
  package: string@"nu-complete void-packages" # Name of package to operate on
]

export extern "./xbps-src remove" [
  package: string@"nu-complete void-packages" # Name of package to operate on
]

export extern "./xbps-src show" [
  package: string@"nu-complete void-packages" # Name of package to operate on
]

export extern "./xbps-src show-avail" [
  package: string@"nu-complete void-packages" # Name of package to operate on
]

export extern "./xbps-src show-build-deps" [
  package: string@"nu-complete void-packages" # Name of package to operate on
]

export extern "./xbps-src show-deps" [
  package: string@"nu-complete void-packages" # Name of package to operate on
]

export extern "./xbps-src show-files" [
  package: string@"nu-complete void-packages" # Name of package to operate on
]

export extern "./xbps-src show-hostmakedepends" [
  package: string@"nu-complete void-packages" # Name of package to operate on
]

export extern "./xbps-src show-makedepends" [
  package: string@"nu-complete void-packages" # Name of package to operate on
]

export extern "./xbps-src show-options" [
  package: string@"nu-complete void-packages" # Name of package to operate on
]

export extern "./xbps-src show-shlib-provides" [
  package: string@"nu-complete void-packages" # Name of package to operate on
]

export extern "./xbps-src show-shlib-requires" [
  package: string@"nu-complete void-packages" # Name of package to operate on
]

export extern "./xbps-src sort-dependencies" [
  ...packages: string@"nu-complete void-packages" # Name of packages to operate on
]

export extern "./xbps-src update-check" [
  package: string@"nu-complete void-packages" # Name of package to operate on
]

export def xedit [package: string@"nu-complete void-packages"] {
  nu -c $"($env.EDITOR) ($env.HOME)/void-packages/srcpkgs/($package)/template"
}
