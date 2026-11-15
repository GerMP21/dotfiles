# Login shell only. zsh reads .zshenv before this and .zshrc after it,
# so don't source either here.

# Some laptops boot with Wi-Fi soft-blocked
command -v rfkill >/dev/null && rfkill unblock wifi 2>/dev/null

# Start niri when you log in on tty1 (Arch wiki "Start X at Login" pattern).
# -l tells niri-session it is already running in a login shell. Without it,
# niri-session re-runs itself through `$SHELL -l -c`, that shell reads this
# file again, and it loops forever without ever starting niri.
if [[ -z $WAYLAND_DISPLAY && $XDG_VTNR == 1 ]]; then
    exec niri-session -l
    # Only reached if niri-session couldn't be run at all
    print -u2 "niri-session failed to start; see: journalctl --user -b -u niri"
fi
