# add ~/bin to PATH if not yet done
if grep -v "${HOME}/bin" <( echo "${PATH}" ) 2>&1 > /dev/null
then
    export PATH="${PATH}:${HOME}/bin"
fi

# Setup terminal, and turn on colors
export CLICOLOR=1

# show command runtime if >10s
export MINIMUM_COMMAND_DURATION_SHOWN=10

# key timeout
export KEYTIMEOUT=1

# vim
if which nvim 2>&1 > /dev/null
then
    export EDITOR=$(which nvim)
elif which vim 2>&1 > /dev/null
then
    export EDITOR=$(which vim)
else
    export EDITOR=$(which vi)
fi

# pass: copy to primary
export PASSWORD_STORE_X_SELECTION=primary

export LESS='--ignore-case --raw-control-chars --quit-if-one-screen --no-init'
export PAGER='less'

export MANPAGER="/bin/sh -c \"col -b | nvim -c 'set ft=man ts=8 nomod nolist nonu noma' -\""

# use GPG as ssh agent
export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
gpgconf --launch gpg-agent
