[ -f $HOME/.bashrc ] && . $HOME/.bashrc

rfkill unblock wifi &
setxkbmap es &
xsetroot -cursor_name left_ptr &

if [[ -z $DISPLAY ]] && [[ $(tty) = /dev/tty1 ]]; then
    exec startx
fi 
