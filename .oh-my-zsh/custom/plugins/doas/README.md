# doas

Easily prefix your current or previous commands with `doas` by pressing <kbd>esc</kbd> twice.

To use it, add `doas` to the plugins array in your zshrc file:

```zsh
plugins=(... doas)
```

## Usage

### Current typed commands

Say you have typed a long command and forgot to add `doas` in front:

```console
$ apt-get install build-essential
```

By pressing the <kbd>esc</kbd> key twice, you will have the same command with `doas` prefixed without typing:

```console
$ doas apt-get install build-essential
```

### Previous executed commands

Say you want to delete a system file and denied:

```console
$ rm some-system-file.txt
-su: some-system-file.txt: Permission denied
$
```

By pressing the <kbd>esc</kbd> key twice, you will have the same command with `doas` prefixed without typing:

```console
$ rm some-system-file.txt
-su: some-system-file.txt: Permission denied
$ doas rm some-system-file.txt
Password:
$
```

## Key binding

By default, the `doas` plugin uses <kbd>Esc</kbd><kbd>Esc</kbd> as the trigger.
If you want to change it, you can use the `bindkey` command to bind it to a different key:

```sh
bindkey -M emacs '<seq>' doas-command-line
bindkey -M vicmd '<seq>' doas-command-line
bindkey -M viins '<seq>' doas-command-line
```

where `<seq>` is the sequence you want to use. You can find the keyboard sequence
by running `cat` and pressing the keyboard combination you want to use.
