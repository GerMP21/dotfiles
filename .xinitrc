if [ -d /etc/X11/xinit/xinitrc.d ]; then
	for f in /etc/X11/xinit/xinitrc.d/*; do
		[ -x "$f" ] && . "$f"
	done
	unset f
fi

export $(dbus-launch) &

pipewire &
pipewire-pulse &
wireplumber &

sleep 5

exec openbox-session
