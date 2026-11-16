# Login shell only. zsh reads .zshenv before this and .zshrc after it,
# so don't source either here. SDDM's session script and niri-session both
# run it when you log in, so niri gets the same environment.

# Some laptops boot with Wi-Fi soft-blocked
command -v rfkill >/dev/null && rfkill unblock wifi 2>/dev/null
true   # a failed unblock must not look like a failed login script
