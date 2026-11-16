#!/usr/bin/env bash
# Sets up the desktop around the linked dotfiles: downloads and applies the
# GTK, icon, Qt and cursor themes, creates the folders the configs expect,
# enables the two services CachyOS doesn't, makes zsh your login shell, and
# checks the niri and Noctalia configs.
#
# Run install-packages.sh first; setup-dotfiles.sh can run before or after.
# Safe to run again.
set -euo pipefail

DOTS="$(cd "$(dirname "$0")" && pwd)"

step() { printf '\n\033[1;34m==> %s\033[0m\n' "$*"; }
warn() { printf '\033[1;33m!! %s\033[0m\n' "$*"; }

if [ "$EUID" -eq 0 ]; then
  echo "Run this as your normal user, not root." >&2
  exit 1
fi

# Stop before changing anything if the packages aren't installed yet
missing=()
for cmd in git sassc; do
  command -v "$cmd" >/dev/null || missing+=("$cmd")
done
if [ "${#missing[@]}" -gt 0 ]; then
  echo "Missing: ${missing[*]}. Run install-packages.sh first; nothing was changed." >&2
  exit 1
fi

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

step "GTK and Qt themes, icons and cursor"
# GTK theme and icons: Fausto-Korpsvart/Rose-Pine-GTK-Theme
if git clone -q --depth 1 https://github.com/Fausto-Korpsvart/Rose-Pine-GTK-Theme.git "$TMP/rose-pine-gtk" \
  && (cd "$TMP/rose-pine-gtk/themes" && ./install.sh -c dark -l -d "$HOME/.themes" >/dev/null); then
  mkdir -p "$HOME/.local/share/icons"
  rm -rf "$HOME/.local/share/icons/Rose-Pine-Moon"
  cp -r "$TMP/rose-pine-gtk/icons/Rose-Pine-Moon" "$HOME/.local/share/icons/"
  gtk-update-icon-cache -f "$HOME/.local/share/icons/Rose-Pine-Moon" >/dev/null 2>&1 || true
  echo "installed Rosepine-Dark and Rose-Pine-Moon"
else
  warn "Rose Pine GTK theme failed (it needs git and sassc); run this script again later"
fi

# Cursor: from the AUR package sunity-cursors-git, else from GitHub
if ! ls /usr/share/icons/Sunity-cursors "$HOME/.icons/Sunity-cursors" >/dev/null 2>&1; then
  if git clone -q --depth 1 https://github.com/alvatip/Sunity-cursors.git "$TMP/sunity"; then
    mkdir -p "$HOME/.icons"
    tar -xzf "$TMP/sunity/archives/Sunity-cursors.tar.gz" -C "$HOME/.icons/"
    echo "installed Sunity-cursors"
  else
    warn "Sunity cursors failed to download; run this script again later"
  fi
fi

# Qt: Rose Pine theme for Kvantum (rose-pine/kvantum)
if git clone -q --depth 1 https://github.com/rose-pine/kvantum.git "$TMP/rose-pine-kvantum"; then
  mkdir -p "$HOME/.config/Kvantum"
  rm -rf "$HOME/.config/Kvantum/rose-pine-foam"
  tar -xzf "$TMP/rose-pine-kvantum/dist/rose-pine-foam.tar.gz" -C "$HOME/.config/Kvantum/"
  echo "installed rose-pine-foam for Kvantum"
else
  warn "Rose Pine Kvantum theme failed to download; run this script again later"
fi

step "Folders and theme settings"
command -v xdg-user-dirs-update >/dev/null && xdg-user-dirs-update
mkdir -p "$HOME/Pictures/Screenshots" "$HOME/Projects" "$HOME/org"
# GTK 4 / libadwaita apps ignore settings.ini on Wayland
# Saved first: with pipefail, a pipe into grep -q can fail even on a match
schemas="$(gsettings list-schemas 2>/dev/null || true)"
if grep -qx org.gnome.desktop.interface <<<"$schemas"; then
  gsettings set org.gnome.desktop.interface gtk-theme 'Rosepine-Dark'
  gsettings set org.gnome.desktop.interface icon-theme 'Rose-Pine-Moon'
  gsettings set org.gnome.desktop.interface cursor-theme 'Sunity-cursors'
  gsettings set org.gnome.desktop.interface cursor-size 24
  gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
else
  warn "gsettings schema missing; set the theme later in nwg-look"
fi

step "Services and login shell"
# CachyOS already enabled NetworkManager, Bluetooth, PipeWire and SDDM
# (whose login unlocks the keyring); these two it doesn't
if systemctl list-unit-files power-profiles-daemon.service >/dev/null 2>&1; then
  sudo systemctl enable --now power-profiles-daemon || warn "couldn't enable power-profiles-daemon"
else
  warn "power-profiles-daemon isn't installed; the bar's power profile button won't work"
fi
systemctl --user enable gnome-keyring-daemon.socket || warn "couldn't enable the GNOME keyring socket"
# CachyOS makes fish the default. Only switch when zsh is a valid login shell.
if [ "$(basename "$SHELL")" != "zsh" ]; then
  if grep -qx /usr/bin/zsh /etc/shells; then
    chsh -s /usr/bin/zsh || warn "chsh failed; run it later: chsh -s /usr/bin/zsh"
  else
    warn "/usr/bin/zsh isn't in /etc/shells; your login shell stays $SHELL"
  fi
fi

step "Check the niri and Noctalia configs"
if command -v niri >/dev/null; then
  niri validate || warn "niri validate failed; fix ~/.config/niri/config.kdl before logging in"
fi
if command -v noctalia >/dev/null; then
  noctalia config validate || warn "noctalia config validate failed; fix ~/.config/noctalia/config.toml"
fi

printf '\n\033[1;32mDone.\033[0m Log out, then log back in from the login screen with the niri session.\n'
echo "Then run 'niri msg outputs' to set up monitors."
