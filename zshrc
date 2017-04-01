#
# .zshrc is sourced in interactive shells.
# It should contain commands to set up aliases,
# functions, options, key bindings, etc.
#
#  Not all terminals support this and, of those that do,
#  not all provide facilities to test the support, hence
#  the user should decide based on the terminal type.  Most
#  terminals  support the  colours  black,  red,  green,
#  yellow, blue, magenta, cyan and white, which can be set
#  by name.  In addition. default may be used to set the
#  terminal's default foreground colour.  Abbreviations
#  are allowed; b or bl selects black.
#

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
WORDCHARS="${WORDCHARS:s#/#}"
WORDCHARS="${WORDCHARS:s#.#}"
##############################################################
#key binding stuff to get the right keys to work
# key bindings
bindkey -v

# ESC-v to edit command
autoload edit-command-line; zle -N edit-command-line
bindkey -M vicmd v edit-command-line
#
# search history with pattern
bindkey "^R" history-incremental-pattern-search-backward
bindkey "^S" history-incremental-pattern-search-forward

# search in history with arrow keys
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey '^[[A' up-line-or-beginning-search # Up
bindkey "^[[B" down-line-or-beginning-search # Do

autoload -Uz compinit
compinit

# show normal or insert mode
function zle-line-init zle-keymap-select {
    VIM_PROMPT="%{$fg_bold[yellow]%} [% NORMAL]%  %{$reset_color%}"
    RPS1="${${KEYMAP/vicmd/$VIM_PROMPT}/(main|viins)/}$EPS1"
    zle reset-prompt
}
zle -N zle-line-init
zle -N zle-keymap-select
export KEYTIMEOUT=1

# Use gpg completion for gpg2.
# But still the keys from gpg are completed.
compdef gpg2=gpg

# End of lines added by compinstall
## completion system
_force_rehash() {
      (( CURRENT == 1 )) && rehash
          return 1  # Because we didn't really complete anything
}

zstyle ':completion:*' completer _oldlist _expand _force_rehash _complete _approximate _expand_alias
zstyle ':completion:*:approximate:'    max-errors 'reply=( $((($#PREFIX+$#SUFFIX)/3 )) numeric )' # allow one error for every three characters typed in approximate completer
zstyle ':completion:*:complete:-command-::commands' ignored-patterns '*\~' # don't complete backup files as executables
zstyle ':completion:*:correct:*'       insert-unambiguous true             # start menu completion only if it could find no unambiguous initial string
zstyle ':completion:*:corrections'     format $'%{\e[0;31m%}%d (errors: %e)%{\e[0m%}' #
zstyle ':completion:*:correct:*'       original true                       #
zstyle ':completion:*:default'         list-colors ${(s.:.)LS_COLORS}      # activate color-completion(!)
zstyle ':completion:*:descriptions'    format $'%{\e[0;31m%}completing %B%d%b%{\e[0m%}'  # format on completion
zstyle ':completion:*:*:cd:*:directory-stack' menu yes select              # complete 'cd -<tab>' with menu
#zstyle ':completion:*:expand:*'        tag-order all-expansions           # insert all expansions for expand completer
zstyle ':completion:*:history-words'   list false                          #
zstyle ':completion:*:history-words'   menu yes                            # activate menu
zstyle ':completion:*:history-words'   remove-all-dups yes                 # ignore duplicate entries
zstyle ':completion:*:history-words'   stop yes                            #
zstyle ':completion:*'                 matcher-list 'm:{a-z}={A-Z}'        # match uppercase from lowercase
zstyle ':completion:*:matches'         group 'yes'                         # separate matches into groups
zstyle ':completion:*'                 group-name ''
zstyle ':completion:*:messages'        format '%d'                         #
zstyle ':completion:*:options'         auto-description '%d'               #
zstyle ':completion:*:options'         description 'yes'                   # describe options in full
zstyle ':completion:*:processes'       command 'ps -au$USER'               # on processes completion complete all user processes
zstyle ':completion:*:*:-subscript-:*' tag-order indexes parameters        # offer indexes before parameters in subscripts
zstyle ':completion:*'                 verbose true                        # provide verbose completion information
zstyle ':completion:*:warnings'        format $'%{\e[0;31m%}No matches for:%{\e[0m%} %d' # set format for warnings
zstyle ':completion:*:*:zcompile:*'    ignored-patterns '(*~|*.zwc)'       # define files to ignore for zcompile
zstyle ':completion:correct:'          prompt 'correct to: %e'             #
zstyle ':completion::(^approximate*):*:functions' ignored-patterns '_*'    # Ignore completion functions for commands you don't have:
zstyle ':completion:*'                 special-dirs true                   # Complete also special dirs as ..

# complete manual by their section
zstyle ':completion:*:manuals'    separate-sections true
zstyle ':completion:*:manuals.*'  insert-sections   true
zstyle ':completion:*:man:*'      menu yes select



# Completion caching
zstyle ':completion::complete:*' use-cache on
zstyle ':completion::complete:*' cache-path ~/.zcache
zstyle ':completion:*:cd:*' ignore-parents parent pwd

zstyle ':completion::complete:cd::' tag-order local-directories
zstyle ':completion:*' menu select=2
zstyle ':completion:*' squeeze-slashes true
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:kill:*'   force-list always
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'

CDPATH=.:~:~/git

#I want my umask 0002 if I'm not root
if [[ $(whoami) = root ]]; then
    umask 0022
else
    umask 0002
fi



#setup ~/.dir_colors if one doesn\'t exist
if [ ! -s ~/.dir_colors ]; then
    dircolors -p > ~/.dir_colors
fi
eval `dircolors ~/.dir_colors`

#aliases
alias g='gvim --remote-silent'
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias vi=$(which vim)
alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'
alias ll='ls -lh'
alias sl='ls -lh'
alias la='ls -lah'

show-colors() {
    for line in {0..17}; do
        for col in {0..15}; do
            code=$(( $col * 18 + $line ));
            printf $'\e[38;05;%dm %03d' $code $code;
        done;
        echo;
    done
}

#allow tab completion in the middle of a word
setopt COMPLETE_IN_WORD
setopt CORRECT

## keep background processes at full speed
#setopt NOBGNICE
## restart running processes on exit
#setopt HUP

## history
setopt APPEND_HISTORY
## for sharing history between zsh processes
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY
## ignore duplicate commands in history
setopt HIST_IGNORE_ALL_DUPS

## dirstack
setopt AUTO_PUSHD

## show menu on completion
setopt AUTOLIST AUTO_MENU

## activate extended globbing
setopt EXTENDEDGLOB
## report status of background tasks immediately
setopt NOTIFY

## never ever beep ever
setopt NO_BEEP

## Extend parameters automattically
setopt AUTO_PARAM_KEYS
setopt AUTO_PARAM_SLASH

## disable flow-cotnrol so C-s is working for forward search again
#setopt NOFLOWCONTROL

setopt NOMATCH            # do not print error on non matched patterns
## automatically decide when to page a list of completions
#LISTMAX=0

## Allow Ctrl-S for forward-search.
setopt NOFLOWCONTROL

## disable mail checking
#MAILCHECK=0

autoload -U colors && colors
# set some colors

setopt PROMPT_SUBST

if [[ -f ~/.dir_colors ]] ; then
    eval $(dircolors -b ~/.dir_colors)
elif [[ -f /etc/DIR_COLORS ]] ; then
    eval $(dircolors -b /etc/DIR_COLORS)
fi

if [[ -f ~/.liquidprompt/liquidprompt ]]; then
    # only in interactive sessions, not script or scp
    if [[ $- = *i* ]]
    then
        source ~/.liquidprompt/liquidprompt
        
        # From liquidprompt: override function to add attached sessions
        ################
        # Related jobs #
        ################

        # Display the count of each if non-zero:
        # - detached screens sessions and/or tmux sessions running on the host
        # - attached running jobs (started with $ myjob &)
        # - attached stopped jobs (suspended with Ctrl-Z)
        _lp_jobcount_color()
        {
            (( LP_ENABLE_JOBS )) || return

            local ret=""
            local -i r s

            # Count attached sessions
            if (( _LP_ENABLE_DETACHED_SESSIONS )); then
                local -i attached=0
                (( _LP_ENABLE_SCREEN )) && attached=$(screen -ls 2> /dev/null | \grep -cv '[Dd]etach[^)]*)$')
                (( _LP_ENABLE_TMUX )) && attached+=$(tmux list-sessions 2> /dev/null | \grep -c 'attached')
                [[ -n "$TMUX" ]] && let attached-=1  # ignore current tmux session
                (( attached > 0 )) && ret+="%F{074}${attached}a%f"
            fi

            # Count detached sessions
            if (( _LP_ENABLE_DETACHED_SESSIONS )); then
                local -i detached=0
                (( _LP_ENABLE_SCREEN )) && detached=$(screen -ls 2> /dev/null | \grep -c '[Dd]etach[^)]*)$')
                (( _LP_ENABLE_TMUX )) && detached+=$(tmux list-sessions 2> /dev/null | \grep -cv 'attached')
                if (( detached > 0 ))
                then
                    [[ -n "$ret" ]] && ret+='/'
                    (( detached > 0 )) && ret+="${LP_COLOR_JOB_D}${detached}d${NO_COL}"
                fi
            fi

            # Count running jobs
            if (( r = $(jobs -r | wc -l) )); then
                [[ -n "$ret" ]] && ret+='/'
                ret+="${LP_COLOR_JOB_R}${r}&${NO_COL}"
            fi

            # Count stopped jobs
            if (( s = $(jobs -s | wc -l) )); then
                [[ -n "$ret" ]] && ret+='/'
                ret+="${LP_COLOR_JOB_Z}${s}z${NO_COL}"
            fi

            echo -nE "$ret"
        }
    fi
fi

# aliases
if [[ -f ~/.zsh_profile ]]; then
    source ~/.zsh_profile
fi

export PATH=$PATH:~/bin

# set volume
vol()
{
    if [[ -z $1 ]]; then
        echo "Usage: $0 cmd"
        return 1
    fi

    case $1 in
        mute)
            pactl set-sink-mute 0 toggle
            ;;
        unmute)
            pactl set-sink-mute 0 toggle
            ;;
        *)
            pactl set-sink-volume 0 "$1%"
            ;;
    esac
}

[[ -n "$DISPLAY" && "$TERM" = "xterm" ]] && export TERM=xterm-256color

# better git log
alias gl="tig --all"
alias gd="git diff"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export EDITOR=$(which vim)
export GPG_TTY=$(tty)
