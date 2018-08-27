#!/bin/zsh

function recreate {
    while read line
    do
        cat $line | task import
        rm $line
    done
}

find ${HOME}/.cache -maxdepth 1 -name "task_recur_*" -print | recreate
