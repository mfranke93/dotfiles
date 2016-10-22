# dotfiles

This is my collection of configuration files for my Linux systems. This is
centered around my current notebook, a Lenovo Thinkpad X230 running Arch Linux.

## Installation

The `install` script softlinks all the config files to the appropriate
locations and backups the old config files in that location if they exist. To
install all configurations properly, the script must be called from its own
location.

## Files 
| File name | Description |
|:--------- |:----------- |
| bin/mpvctl | Script to control a running mpv instance.
| i3config | Configuration file for i3 window manager.
| liquidpromptrc | Configuration file for liquidprompt, a shell prompt plugin for zsh.
| mpv\_config | Configuration file for mpv.
| tmuxconf | Configuration file for tmux.
| vimrc | Configuration file for vim.
| xinitrc | X launch script. Sets keyboard layout, xterm configuration, and launches i3.
| Xresources | xterm configuration.
| zshenv | zsh aliases.
| zshrc | Configuration for zsh.
