[ -f $HOME/.bashrc ] && . $HOME/.bashrc

rfkill unblock wifi

if [[ -z $DISPLAY ]] && [[ $(tty) = /dev/tty1 ]]; then
    exec startx
fi 
