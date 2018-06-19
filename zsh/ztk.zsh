# function to create new
function ztk {
    arg=""
    if [[ $# -ge 1 ]]
    then
        arg=""
        for i in {1..$#}
        do
            arg="${arg}\"$@[i]\""
            if [[ $i -lt $# ]]
            then
                arg="${arg}, "
            fi
        done
    fi

    nvim +"call ztk#zettelkasten(${arg})"
}

# function to search
function zg {
    grep -Rsli "$@" ~/ztk | while read filename
        do
            tags=$(echo -n $(head -n1 $filename))
            content_head=$(echo -n $(awk 'NR==5 {print}' $filename))

            echo "$filename $tags $content_head"
        done | fzf -m \
            --preview="cat {1}" \
            --preview-window=up:10 \
            --height=40% \
            --min-height=20 \
            --inline-info \
            --prompt='ztk > ' \
            --bind "ctrl-space:toggle" \
            | awk '{print $1}' | xargs nvim "+set readonly"
}
