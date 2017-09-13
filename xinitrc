xrdb ~/.Xresources
setxkbmap gb -option caps:none,compose:caps
if hostname | grep "^amaterasu$"
then 
    exec i3 > ~/.i3log 2>&1
fi
