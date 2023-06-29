if [ -d /etc/X11/xinit/xinitrc.d ]; then
	for f in /etc/X11/xinit/xinitrc.d/*; do
		[ -x "$f" ] && . "$f"
	done
	unset f
fi

export $(dbus-launch) &

setxkbmap latam &
xsetroot -cursor_name left_ptr &

pipewire &
pipewire-pulse &
wireplumber &

sleep 5

exec bspwm
