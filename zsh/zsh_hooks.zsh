autoload -Uz add-zsh-hook

function termite_title_precmd () {
	print -Pn '\e]2;%n@%m %1~\a'
}

function termite_title_preexec () {
	print -Pn '\e]2;%n@%m %1~ %# '
	print -n "${(q)1}\a"
}

add-zsh-hook -Uz precmd termite_title_precmd
add-zsh-hook -Uz preexec termite_title_preexec
