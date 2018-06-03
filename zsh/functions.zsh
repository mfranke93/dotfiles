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

# -------------------------------------------------------------------
# set volume
# -------------------------------------------------------------------
vol()
{
    if [[ -z $1 ]]; then
        pactl list sinks \
            | awk '/^\s+Mute: yes$/ { print "[muted]" }; /^\s+Volume: .*$/ { print $5 }' \
            | ( i=0 ; while read v; do if [[ $i -eq 0 ]]; then b=$v; i=1; else a=$v; fi; done; echo $a $b )
        return 0
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

# -------------------------------------------------------------------
# Script to combine the creation of a directory and changing into it
# -------------------------------------------------------------------
function mcd {
    if [[ $# -ne 1 ]]
    then
        echo "Usage: $0 <dirname>"
        exit 1
    fi

    mkdir -p "$1"
    cd "$1"
}

