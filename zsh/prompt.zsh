function prompt_char {
    git branch >/dev/null 2>/dev/null && echo '±' && return
    echo '▶'
}


# http://blog.joshdick.net/2012/12/30/my_git_prompt_for_zsh.html
# copied from https://gist.github.com/4415470
# Adapted from code found at <https://gist.github.com/1712320>.

#setopt promptsubst
autoload -U colors && colors # Enable colors in prompt
typeset -AHg FX FG BG
for color in {000..255}; do
  FG[$color]="%{[38;5;${color}m%}"
  BG[$color]="%{[48;5;${color}m%}"
done

# Modify the colors and symbols in these variables as desired.
GIT_PROMPT_SYMBOL="%{$fg[blue]%}±"
GIT_PROMPT_PREFIX="%{$fg[green]%} [%{$reset_color%}"
GIT_PROMPT_SUFFIX="%{$fg[green]%}]%{$reset_color%}"
GIT_PROMPT_AHEAD="%{$FG[196]%}ANUM%{$reset_color%}"
GIT_PROMPT_BEHIND="%{$FG[045]%}BNUM%{$reset_color%}"
GIT_PROMPT_UNTRACKED="%{$FG[196]%}*%{$reset_color%}"
GIT_PROMPT_MODIFIED="%{$fg_bold[yellow]%}d%{$reset_color%}"
GIT_PROMPT_STAGED="%{$fg_bold[green]%}s%{$reset_color%}"
GIT_PROMPT_STASHED="%{$fg_bold[yellow]%}+%{$reset_color%}"
GIT_PROMPT_MERGING="%{$FG[201]%}MERGING%{$reset_color%}"
GIT_PROMPT_REBASING="%{$FG[201]%}REBASING%{$reset_color%}"
GIT_PROMPT_CHERRYPICKING="%{$FG[201]%}CHERRY-PICKING%{$reset_color%}"

# Show Git branch/tag, or name-rev if on detached head
function parse_git_branch() {
  (git symbolic-ref -q HEAD || git name-rev --name-only --no-undefined --always HEAD) 2> /dev/null
}

function hostname_colored() {
    if [ -f ~/.host-color ]
    then
        echo -nE "%{$FG[$(cat ~/.host-color)]%}"
    else
        local cksum="$(hostname | cksum)"
        echo -n "%{$(tput setaf $(( 1 + ${cksum%%[ 	]*} % 6 )) )%}"
    fi
    echo -n `hostname -s`
    echo -n "%{$reset_color%}"
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
        untracked="$GIT_PROMPT_UNTRACKED"
    fi

    # check if stashes exist
    if [[ -n "$(\git stash list -n 1 2>/dev/null)" ]]; then
        stashed="$GIT_PROMPT_STASHED"
    fi

    # check if ahead or behind of remote
    if [[ -n "$remote" ]]; then
        local remote_branch="$(\git config --get branch.${branchname}.merge)"
        if [[ -n "$remote_branch" ]]; then
            remote_branch=${remote_branch/refs\/heads/refs\/remotes\/$remote}
            commit_ahead="$(\git rev-list --count $remote_branch..HEAD 2>/dev/null)"
            commit_behind="$(\git rev-list --count HEAD..$remote_branch 2>/dev/null)"
            if [[ "$commit_ahead" -ne "0" && "$commit_behind" -ne "0" ]]; then
                has_commit="%{$FG[196]%}+$commit_ahead%{$reset_color%}/%{$fg[cyan]%}-$commit_behind%{$reset_color%}"
            elif [[ "$commit_ahead" -ne "0" ]]; then
                has_commit="%{$fg[yellow]%}$commit_ahead%{$reset_color%}"
            elif [[ "$commit_behind" -ne "0" ]]; then
                has_commit="%{$FG[045]%}-$commit_behind%{$reset_color%}"
            fi
        fi
    fi

    local has_lines
    local shortstat # only to check for uncommitted changes
    shortstat="$(LC_ALL=C \git diff --shortstat HEAD 2>/dev/null)"

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

        has_lines="%{$fg[green]%}+$i_lines%{$reset_color%}/%{$FG[196]%}-$d_lines%{$reset_color%}"
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

    local ret="on "
    ret="$ret%{$fg[$branchname_color]%}$branchname%{$reset_color%}"
    ret="$ret$untracked$stashed"
    ret="$ret$state"

    if [[ -n "$has_lines" ]]; then
        if [[ -n "$has_commit" ]]; then
            ret="$ret($has_lines,$has_commit)"
        else
            ret="$ret($has_lines)"
        fi
    elif [[ -n "$has_commit" ]]; then
        ret="$ret($has_commit)"
    fi

    echo -n "$ret"
}

function current_pwd {
  echo $(pwd | sed -e "s,^$HOME,~,")
}

function current_jobs_tmux {
    local ret=""
    local -i r s

    # Count detached sessions
    local -i detached=0
    detached+=$(tmux list-sessions 2> /dev/null | \grep -cv 'attached')
    (( detached > 0 )) && ret+="%{$fg[yellow]%}${detached}d%{$reset_color%}"

    # Count attached sessions
    local -i attached=0
    attached+=$(tmux list-sessions 2> /dev/null | \grep -c 'attached')
    if [[ "$attached" -gt "0" ]]; then
        [[ -n "$ret" ]] && ret+='/'
        ret+="%{$fg[blue]%}${attached}a%{$reset_color%}"
    fi

    # Count running jobs
    if (( r = $(jobs -r | wc -l) )); then
        [[ -n "$ret" ]] && ret+='/'
        ret+="%{$fg[green]%}${r}&%{$reset_color%}"
    fi

    # Count stopped jobs
    if (( s = $(jobs -s | wc -l) )); then
        [[ -n "$ret" ]] && ret+='/'
        ret+="%{$FG[208]%}${s}z%{$reset_color%}"
    fi

    if [[ -n "$ret" ]]; then
        echo -nE "[$ret]"
    else
        echo -nE ""
    fi
}

function last_return_value {
    local retval="$?"
    if [[ "$retval" -gt "0" ]]; then
        echo -nE "%{$FG[196]%}$retval%{$reset_color%} "
    fi
}

function is_ssh {
    if [[ -n "$SSH_CLIENT" ]]; then
        echo -ne "%{$FG[045]%}"
    elif [[ -n "$SSH_TTY" ]]; then
        echo -ne "%{$FG[045]%}"
    else
        echo -ne "%{$fg[white]%}"
    fi
}


PROMPT='
 $(last_return_value)$(current_jobs_tmux) ${PR_GREEN}%n%{$reset_color%}$(is_ssh)@%{$reset_color%}$(hostname_colored)%{$FG[246]%}:%{$reset_color%}${PR_BOLD_YELLOW}$(current_pwd)%{$reset_color%} $(parse_git_state)
$(prompt_char) '

