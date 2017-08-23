# -------------------------------------------------------------------
# any function from http://onethingwell.org/post/14669173541/any
# search for running processes
# -------------------------------------------------------------------
any() {
    emulate -L zsh
    unsetopt KSH_ARRAYS
    if [[ -z "$1" ]] ; then
        echo "any - grep for process(es) by keyword" >&2
        echo "Usage: any " >&2 ; return 1
    else
        ps xauwww | grep -i --color=auto "[${1[1]}]${1[2,-1]}"
    fi
}

# -------------------------------------------------------------------
# Show terminal colors
# -------------------------------------------------------------------
show-colors() {
for line in {0..17}; do
    for col in {0..15}; do
        code=$(( $col * 18 + $line ));
        printf $'\e[38;05;%dm %03d' $code $code;
    done;
    echo;
done
}
