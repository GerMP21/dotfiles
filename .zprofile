# Login shell only. zsh reads .zshenv before this and .zshrc after it,
# so don't source either here.

# Some laptops boot with Wi-Fi soft-blocked
command -v rfkill >/dev/null && rfkill unblock wifi 2>/dev/null

# Start niri when you log in on tty1. The -o interactive check matters:
# niri-session re-runs itself through a non-interactive login shell
# (`zsh -l -c ...`) to pick up your environment, and that shell reads this
# file too. Without the check it would call niri-session again, forever.
if [[ -o interactive && -z $WAYLAND_DISPLAY && $(tty) = /dev/tty1 ]]; then
    exec niri-session
fi
