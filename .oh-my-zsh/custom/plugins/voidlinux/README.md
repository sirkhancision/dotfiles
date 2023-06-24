# Void Linux plugin

This plugin adds some aliases and functions to work with Void Linux.

To use it, add `voidlinux` to the plugins array in your zshrc file:

```zsh
plugins=(... voidlinux)
```

## Features

### XBPS

| Alias        | Command                                | Description                                          |
|--------------|----------------------------------------|------------------------------------------------------|
| xalt         | `sudo\|doas xbps-alternatives -s`      | Print alternatives to the package(s)                 |
| xalts        | `sudo\|doas xbps-alternatives -l`      | Print alternatives to all installed packages         |
| xclean       | `sudo\|doas xbps-remove -Oo`           | Remove outdated and orphaned packages from the cache |
| xdb          | `xbps-pkgdb`                           | Check package(s) in the package database             |
| xdba         | `xbps-pkgdb -a`                        | Check all installed packages in the package database |
| xf           | `xbps-fetch`                           | Download file                                        |
| xqh          | `xbps-query -H`                        | Query packages put on hold                           |
| xqo          | `xbps-query -O`                        | Query orphaned packages                              |
| xr           | `sudo\|doas xbps-remove`               | Remove package(s)                                    |
| xrc          | `sudo\|doas xbps-reconfigure`          | Re-configure package(s) on the system                |
| xrca         | `sudo\|doas xbps-reconfigure -a`       | Re-configure all packages on the system              |
| xrr          | `sudo\|doas xbps-remove -R`            | Remove package(s) recursively with dependencies      |
| xrsr         | `xbps-query --regex -Rs`               | Search for packages in the repositories using regex  |
| xu           | `sudo\|doas xbps-install -Su`          | Update the packages installed                        |
| xuu          | `xbps-src-update`                      | Update the packages installed, through void-packages |
| xver         | `xbps-checkvers -If%n %r -> %s`        | List packages with updates                           |

### Services

| Function              | Description                         |
|-----------------------|-------------------------------------|
| sv-enable _service_   | Enables the selected runit service  |
| sv-disable  _service_ | Disables the selected runit service |
