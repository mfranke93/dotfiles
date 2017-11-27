xrdb ~/.Xresources
setxkbmap gb -option caps:none,compose:caps
if hostname | grep "^amaterasu$"
then
    exec awesome
fi
