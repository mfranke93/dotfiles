xrdb ~/.Xresources
setxkbmap gb -option caps:none,compose:caps
if hostname | grep -e "^amaterasu\|ivy$"
then
    exec i3 2>&1 > ~/.i3-log
fi
