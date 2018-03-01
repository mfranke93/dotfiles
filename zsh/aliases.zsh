alias g='nvr --remote-silent'
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'
alias ll='ls -lh'
alias sl='ls -lh'
alias la='ls -lah'

# EDITOR
if which nvim 2>&1 > /dev/null
then
    alias vi=nvim
elif which vim 2>&1 > /dev/null
then
    alias vi=vim
fi

# git
alias gl="tig --all"
alias gd="git diff"

# no idea why it isn't working otherwise
alias git='GPG_TTY=$(tty) git'

# :)
alias wtf='dmesg'

# :))
alias :q=exit
