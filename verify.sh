#!/usr/bin/env bash
# Checks that the install worked: packages, links, configs, services, themes,
# tools, and the encrypted UEFI boot. Prints a ✓ or ✗ per check and changes
# nothing.
#
#   ./verify.sh            all checks; asks for sudo once, only to read the
#                          boot partition and the encryption header
#   ./verify.sh --no-sudo  skip the checks that need sudo
#
# Exits 1 if any check failed.
set -uo pipefail

DOTS="$(cd "$(dirname "$0")" && pwd)"
SRC="$DOTS/home"
USE_SUDO=1
case "${1:-}" in
  "") ;;
  --no-sudo) USE_SUDO=0 ;;
  -h|--help) sed -n '2,10p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
  *) echo "Unknown option: $1 (try --help)" >&2; exit 2 ;;
esac

PASS=0 FAIL=0 SKIP=0
ok()      { printf '  \033[32m✓\033[0m %s\n' "$*"; PASS=$((PASS + 1)); }
bad()     { printf '  \033[31m✗\033[0m %s\n' "$*"; FAIL=$((FAIL + 1)); }
skip()    { printf '  \033[33m-\033[0m %s\n' "$*"; SKIP=$((SKIP + 1)); }
section() { printf '\n\033[1;34m%s\033[0m\n' "$*"; }
has()     { command -v "$1" >/dev/null 2>&1; }
# check "<description>" <command...>: ✓ if the command succeeds
check()   { local d="$1"; shift; if "$@" >/dev/null 2>&1; then ok "$d"; else bad "$d"; fi; }
pkglist() { grep -v '^\s*#' "$1" | grep -v '^\s*$'; }

section "Packages"
if has pacman; then
  for list in packages.txt packages-aur.txt; do
    mapfile -t missing < <(pacman -T $(pkglist "$DOTS/$list") 2>/dev/null)
    if [ "${#missing[@]}" -eq 0 ]; then
      ok "everything in $list is installed"
    else
      bad "$list: not installed: ${missing[*]}  (run install-packages.sh)"
    fi
  done
else
  bad "pacman not found; this isn't CachyOS/Arch"
fi
if has pipx; then
  for p in $(pkglist "$DOTS/packages-pipx.txt"); do
    if pipx list --short 2>/dev/null | grep -q "^$p "; then ok "pipx: $p"; else bad "pipx: $p isn't installed (pipx install $p)"; fi
  done
else
  bad "pipx not found (python-pipx in packages.txt)"
fi

section "Dotfiles linked from $SRC"
# The same paths setup-dotfiles.sh links
paths=(.zshenv .zshrc .zprofile .gtkrc-2.0 .icons/default/index.theme
       .config/starship.toml .local/share/goodvibes/stations.xml .local/share/backgrounds/wallpaper.jpg)
for d in "$SRC"/.config/*/; do
  name="$(basename "$d")"
  case "$name" in
    gtk-2.0|gtk-3.0|gtk-4.0|Kvantum|xdg-desktop-portal)
      for f in "$d"*; do paths+=(".config/$name/$(basename "$f")"); done ;;
    *) paths+=(".config/$name") ;;
  esac
done
unlinked=()
for p in "${paths[@]}"; do
  [ "$(readlink "$HOME/$p")" = "$SRC/$p" ] || unlinked+=("~/$p")
done
if [ "${#unlinked[@]}" -eq 0 ]; then
  ok "all ${#paths[@]} configs are linked"
else
  bad "not linked: ${unlinked[*]}  (run setup-dotfiles.sh)"
fi
mapfile -t broken < <(find "$HOME" -maxdepth 5 -xtype l -lname "$DOTS/*" 2>/dev/null)
if [ "${#broken[@]}" -eq 0 ]; then ok "no broken links into the repo"; else bad "broken links: ${broken[*]}"; fi
nofont=()
for f in "$SRC"/.local/share/fonts/*; do
  [ -f "$HOME/.local/share/fonts/$(basename "$f")" ] || nofont+=("$(basename "$f")")
done
if [ "${#nofont[@]}" -eq 0 ]; then ok "bundled fonts copied"; else bad "fonts not copied: ${nofont[*]}"; fi

section "Configs"
if has niri; then
  if out="$(niri validate 2>&1)"; then ok "niri validate"; else bad "niri validate:"; printf '%s\n' "$out" | sed 's/^/      /' | head -15; fi
else
  bad "niri not found"
fi
if has noctalia; then
  if out="$(noctalia config validate 2>&1)"; then ok "noctalia config validate"; else bad "noctalia config validate:"; printf '%s\n' "$out" | sed 's/^/      /' | head -15; fi
else
  bad "noctalia not found"
fi

section "Login shell and services"
shell="$(getent passwd "$(id -un)" | cut -d: -f7)"
if [ "$shell" = /usr/bin/zsh ]; then ok "login shell is zsh"; else bad "login shell is $shell, not zsh (chsh -s /usr/bin/zsh)"; fi
if has systemctl; then
  for unit in sddm NetworkManager bluetooth power-profiles-daemon; do
    check "$unit enabled" systemctl is-enabled "$unit"
  done
  for unit in pipewire.socket wireplumber.service gnome-keyring-daemon.socket; do
    check "$unit enabled (user)" systemctl --user is-enabled "$unit"
  done
else
  bad "systemctl not found"
fi

section "Themes and fonts"
check "GTK theme Rosepine-Dark"     test -d "$HOME/.themes/Rosepine-Dark"
check "icon theme Rose-Pine-Moon"   test -d "$HOME/.local/share/icons/Rose-Pine-Moon"
check "Qt theme rose-pine-foam"     test -d "$HOME/.config/Kvantum/rose-pine-foam"
if [ -d /usr/share/icons/Sunity-cursors ] || [ -d "$HOME/.icons/Sunity-cursors" ]; then ok "cursor theme Sunity-cursors"; else bad "cursor theme Sunity-cursors"; fi
if has gsettings && theme="$(gsettings get org.gnome.desktop.interface gtk-theme 2>/dev/null)"; then
  if [ "$theme" = "'Rosepine-Dark'" ]; then ok "gsettings applies Rosepine-Dark"; else bad "gsettings theme is $theme (run setup-dotfiles.sh)"; fi
else
  skip "gsettings not readable here (run this inside the niri session)"
fi
if has fc-list; then
  for font in "JetBrainsMono Nerd Font" "Iosevka Nerd Font"; do
    if fc-list : family | grep -qi "$font"; then ok "font: $font"; else bad "font: $font"; fi
  done
fi

section "Editors and tools"
check "trustsight runs"                  trustsight --version
check "Doom Emacs installed"             test -x "$HOME/.config/emacs/bin/doom"
check "Neovim plugins installed"         test -d "${XDG_DATA_HOME:-$HOME/.local/share}/nvim/lazy/telescope.nvim"
check "Telescope fzf extension built"    test -f "${XDG_DATA_HOME:-$HOME/.local/share}/nvim/lazy/telescope-fzf-native.nvim/build/libfzf.so"
if compgen -G "${XDG_DATA_HOME:-$HOME/.local/share}/nvim/mason/bin/*" >/dev/null; then ok "Mason language servers installed"; else bad "Mason language servers installed (:Mason in nvim)"; fi

section "Boot and encryption"
check "booted in UEFI mode"               test -d /sys/firmware/efi
if has efibootmgr; then
  if efibootmgr 2>/dev/null | grep -qiE 'limine|linux boot manager'; then ok "firmware has a Limine or systemd-boot entry"; else bad "no Limine or systemd-boot entry in the firmware (efibootmgr)"; fi
else
  skip "efibootmgr not installed; can't list the firmware boot entries"
fi
luks="$(lsblk -rno PATH,FSTYPE 2>/dev/null | awk '$2 == "crypto_LUKS" { print $1; exit }')"
if [ -n "$luks" ]; then ok "encrypted partition: $luks"; else bad "no LUKS-encrypted partition found (lsblk -f)"; fi
if [ "$USE_SUDO" -eq 1 ] && has sudo && sudo -v; then
  if sudo test -f /boot/limine.conf; then
    ok "Limine config /boot/limine.conf exists"
  elif sudo test -d /boot/loader/entries; then
    ok "systemd-boot entries exist in /boot/loader/entries"
  else
    bad "no bootloader config in /boot (limine.conf or loader/entries)"
  fi
  if [ -n "$luks" ]; then
    # LUKS2 lists "  0: luks2", LUKS1 lists "Key Slot 0: ENABLED"
    slots="$(sudo cryptsetup luksDump "$luks" 2>/dev/null | grep -cE '^\s+[0-9]+: luks2|^Key Slot [0-9]+: ENABLED')"
    if [ "$slots" -ge 2 ]; then ok "$slots passphrases on $luks (backup added)"; else bad "only $slots passphrase on $luks; add a backup (README 1.6)"; fi
  fi
else
  skip "bootloader config and backup passphrase (need sudo)"
fi

printf '\n\033[1m%d passed, %d failed, %d skipped\033[0m\n' "$PASS" "$FAIL" "$SKIP"
if [ "$FAIL" -gt 0 ]; then
  echo "Fix the ✗ lines (most say what to run), then run ./verify.sh again."
  exit 1
fi
echo "All good. Last checks need you: reboot without the USB stick, then go through the README's Part 3.2 checklist."
