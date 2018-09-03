autoload -U colors && colors # Enable colors in prompt

function prompt_pwd {
    echo -n "%F{yellow}%~%f "
}

function prompt_detached_zombie {
    local ret=""
    local -i r s

    # Count running jobs
    if (( r = $(jobs -r | wc -l) )); then
        ret+="%F{green}${r}&%f"
    fi

    # Count stopped jobs
    if (( s = $(jobs -s | wc -l) )); then
        [[ -n "$ret" ]] && ret+='/'
        ret+="%F{blue}${s}z%f"
    fi

    if [[ -n "$ret" ]]
    then
        echo -n "$ret "
    fi
}

function precmd {
    _last_retval=$?
}

function prompt_prompt {
    if [[ $_last_retval = 0 ]]
    then
        echo -n '%F{cyan}%Bλ%b%f'
    else
        echo -n "%F{red}%Bλ%b%f"
    fi
}

GIT_PROMPT_MERGING="%F{magenta}MERGING%f"
GIT_PROMPT_REBASING="%F{magenta}REBASING%f"
GIT_PROMPT_CHERRYPICKING="%F{magenta}CHERRY-PICKING%f"

# Show Git branch/tag, or name-rev if on detached head
function parse_git_branch() {
  (git symbolic-ref -q HEAD || git name-rev --name-only --no-undefined --always HEAD) 2> /dev/null
}

function parse_git_state() {
    local git_where=$(parse_git_branch)
    [ -n "${git_where}" ] || return
    branchname="${git_where#(refs/heads/|tags/)}"

    # variables
    local remote="$(\git config --get branch.$branchname.remote 2>/dev/null)"
    local has_commit=""
    local commit_ahead
    local commit_behind
    local stashed=""
    local untracked=""
    local gitdir="$(\git rev-parse --git-dir 2>/dev/null)"
    local state=" "
    
    # check if untracked files
    if LC_ALL=C \git status --porcelain 2>/dev/null | \grep -Eq '^\?\?'; then
        untracked="%F{cyan}*%f"
    fi

    # check if stashes exist
    if [[ -n "$(\git stash list -n 1 2>/dev/null)" ]]; then
        stashed="%F{yellow}+%f"
    fi

    # check if ahead or behind of remote
    if [[ -n "$remote" ]]; then
        local remote_branch="$(\git config --get branch.${branchname}.merge)"
        if [[ -n "$remote_branch" ]]; then
            remote_branch=${remote_branch/refs\/heads/refs\/remotes\/$remote}
            commit_ahead="$(\git rev-list --count $remote_branch..HEAD 2>/dev/null)"
            commit_behind="$(\git rev-list --count HEAD..$remote_branch 2>/dev/null)"
            if [[ "$commit_ahead" -ne "0" && "$commit_behind" -ne "0" ]]; then
                has_commit="%F{blue}+$commit_ahead%f/%F{cyan}-$commit_behind%f"
            elif [[ "$commit_ahead" -ne "0" ]]; then
                has_commit="%F{blue}+$commit_ahead%f"
            elif [[ "$commit_behind" -ne "0" ]]; then
                has_commit="%F{cyan}-$commit_behind%f"
            fi
        fi
    fi

    local has_lines
    local shortstat # only to check for uncommitted changes
    shortstat="$(LC_ALL=C \git diff --shortstat HEAD 2>/dev/null)"
    local binchanges
    binchanges="$(LC_ALL=C \git diff --numstat 2>/dev/null | grep -c '^-\s\+-')"

    if (( $binchanges > 0 ))
    then
        has_lines="%F{magenta}b%F{black},"
    fi

    # check if unstaged changes
    if [[ -n "$shortstat" ]]; then
        local u_stat # shorstat of *unstaged* changes
        u_stat="$(LC_ALL=C \git diff --shortstat 2>/dev/null)"
        u_stat=${u_stat/*changed, /} # removing "n file(s) changed"

        local i_lines # inserted lines
        if [[ "$u_stat" = *insertion* ]]; then
            i_lines=${u_stat/ inser*}
        else
            i_lines=0
        fi

        local d_lines # deleted lines
        if [[ "$u_stat" = *deletion* ]]; then
            d_lines=${u_stat/*\(+\), }
            d_lines=${d_lines/ del*/}
        else
            d_lines=0
        fi

        has_lines="${has_lines}%F{green}+$i_lines%F{black}/%F{red}-$d_lines%f"
    fi
    
    # set color of branch name depending on local and remote state: red if uncommitted changes,
    # yellow if unpushed commits, blue if local branch with no uncommitted, green if remote and up-to-date
    local branchname_color
    if [[ -n "$remote" ]]; then
        # remote branch
        if [[ -n "$has_lines" ]]; then
            branchname_color="red"
        else
            # no modifications
            if [[ "$commit_ahead" -ne "0" ]]; then
                # local commits not pushed
                branchname_color="yellow"
            else
                branchname_color="green"
            fi
        fi
    else
        # local branch
        if [[ -n "$has_lines" ]]; then
            branchname_color="red"
        else
            # no modifications
            branchname_color="blue"
        fi
    fi

    # check if in merge, rebase or cherry-pick
    if [[ -f "${gitdir}/MERGE_HEAD" ]]; then
        state="$state${GIT_PROMPT_MERGING} "
    elif [[ -d "${gitdir}/rebase-apply" || -d "${gitdir}/rebase-merge" ]]; then
        state="$state${GIT_PROMPT_REBASING} "
    elif [[ -f "${gitdir}/CHERRY_PICK_HEAD" ]]; then
        state="$state${GIT_PROMPT_CHERRYPICKING} "
    fi


    ############################################################################
    # BUILD PROMPT STRING

    local ret=""
    ret="$ret%F{$branchname_color}$branchname%f"
    ret="$ret$untracked$stashed"
    ret="$ret$state"

    if [[ -n "$has_lines" ]]; then
        if [[ -n "$has_commit" ]]; then
            ret="$ret%F{black}($has_lines%F{black},$has_commit%F{black})"
        else
            ret="$ret%F{black}($has_lines%F{black})"
        fi
    elif [[ -n "$has_commit" ]]; then
        ret="$ret%F{black}($has_commit%F{black})"
    fi

    echo -n "$ret"
}

function is_ssh {
    if [[ -n "$SSH_CLIENT" ]]; then
        echo -ne "%F{cyan}%n%F{yellow}@%F{green}%m%f:"
    elif [[ -n "$SSH_TTY" ]]; then
        echo -ne "%F{cyan}%n%F{yellow}@%F{green}%m%f:"
    fi
}

export PROMPT=' $(is_ssh)$(prompt_pwd)$(prompt_detached_zombie)$(prompt_prompt) '
export RPROMPT='$(parse_git_state)'

export KEYTIMEOUT=5
# do cursor change on normal mode
function zle-line-init zle-keymap-select {
    # do not do this in tty
    if [[ "$TERM" = "linux" ]]
    then
        :
    else
        case $KEYMAP in
            viins|main) print -n -- '\e]12;#E5E9F0\a\e[5 q' ;;
            vicmd) print -n -- '\e]12;#A3BE8C\a\e[1 q' ;;
        esac
    fi
}

zle -N zle-line-init
zle -N zle-keymap-select
