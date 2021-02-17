# ZSH quickjump plugin

Adds tab completion support for [skim](https://github.com/lotabout/skim) for recent files and directories using [fasd](https://github.com/whjvenyl/fasd).
The following three commands are supported:

```sh
j - jump to a recent directory (fasd -Rdl)
f - edit a recent file (fasd -Rfl)
v - visit a recent file (fasd -Rfl)
```

The `j` command is covered by fasd. For `f` and `v` add the following aliases:

```sh
alias f=$EDITOR
alias v=xdg-open
```
