[ -f "$HOME/.zshrc" ] && . "$HOME/.zshrc"

# Some laptops boot with Wi-Fi soft-blocked
command -v rfkill >/dev/null && rfkill unblock wifi 2>/dev/null

if [[ -z $WAYLAND_DISPLAY ]] && [[ $(tty) = /dev/tty1 ]]; then
    exec niri-session
fi
