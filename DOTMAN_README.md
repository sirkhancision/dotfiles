# dotman

dotman is a Python script that acts as a minimalist dotfiles manager.

## How to use it:

### You'll be able to:

- Link your files and directories (no system-wide files)

- Edit your files

- Update your dotfiles from a remote repository

### To add new files to dotman:

1. Create the file or directory within the path pointed to by the `REPO_DIR` variable (e.g. `~/dotfiles`)

2. Put its name and path as a new line in `dotman_files`

   - If it's a directory, everything inside it will be linked, so something like `~/.config` will link every file and directory inside `~/.config`

3. You'll probably want to link the new file to its path outside of `REPO_DIR`, (e.g. link `REPO_DIR/.config/sway` to `~/.config/sway`), so:
   
   1. Run dotman (`./dotman`)
   
   2. Select the option to link your dotfiles
   
   3. After that, your new file or directory will have been linked to its correct path

***dotman doesn't link files to directories with root permissions (e.g. `/etc`), so you should do this manually if you have such files.***

## To edit files:

Files must be properly added properly as described in "*To add new files to dotman*".

All you have to do is run dotman (`./dotman`) and select to edit your files, which will show you the list of your text-based files, along with a syntax-highlighted preview on the side. When you select a file, it will open it with your default editor (for example, if vim is set as the value for the `EDITOR` environment variable, it'll open the file with it).

### Dependencies:

- [bat](https://github.com/sharkdp/bat)

- [fd](https://github.com/sharkdp/fd)

- [skim](https://github.com/lotabout/skim)

- Any text editor set as the default editor (set as the value of the `EDITOR` environment variable)
