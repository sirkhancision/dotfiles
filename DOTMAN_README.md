# dotman

dotman is a POSIX shell script that acts as a minimalist dotfiles manager.

## How to use it:

### You'll be able to:

- Link your files and directories (no system-wide files)

- Edit your files

### To add new files to dotman:

1. Create the file or directory inside the path pointed to by the variable `REPO_DIR`

2. Put its name and relative path (relative to `REPO_DIR`) as a new line in the pseudo-array `FILES` (the order doesn't matter)

3. You'll probably want to link the new file to its path outside of `REPO_DIR`, (e.g. link `REPO_DIR/.config/i3` to `~/.config/i3`), so:
   
   1. Run dotman (`./dotman.sh`)
   
   2. Select the option to link your dotfiles
   
   3. After that, your new file or directory will have been linked to its correct path

***dotman doesn't link files to directories with root permissions (e.g. `/etc`), therefore you should do that manually, if you have such files.***

## To edit files:

Files must be properly added according to what's described in "*To add new files to dotman*".

You only need to run dotman (`./dotman.sh`) and select to edit your files, which will show you the list of your text-based files, along with a syntax-highlighted preview to the side. When you select a file, it'll open it with your default editor (for example, if vim is set as the value for the `EDITOR` environment variable, it'll open the file with vim).

### To remove files:

By the minimalist nature of dotman, in order to remove a file, you'd do it as with a regular file (`rm example_file`), and removing the line corresponding to it inside the `FILES` pseudo-array.

### Dependencies:

- [fd](https://github.com/sharkdp/fd)

- [skim](https://github.com/lotabout/skim)

- [bat](https://github.com/sharkdp/bat)

- Any text editor set as the default editor (set as the value for the `EDITOR` environment variable)
