# Currently this path is appended to dynamically when picking a ruby version
# zshenv has already started PATH with rbenv so append only here
export PATH=$PATH:$HOME/bin

# Setup terminal, and turn on colors
export TERM=xterm-256color
export CLICOLOR=1

# key timeout
export KEYTIMEOUT=1

# vim
export EDITOR=$(which nvim)

# pass: copy to primary
export PASSWORD_STORE_X_SELECTION=primary

export LESS='--ignore-case --raw-control-chars'
export PAGER='less'

