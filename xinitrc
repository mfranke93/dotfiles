xrdb ~/.Xresources
setxkbmap gb -option caps:none,compose:caps
export GTK_IM_MODULE=ibus
export XMODIFIERS=@im=ibus
export QT_IM_MODULE=ibus
exec i3
