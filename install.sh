#!/usr/bin/env bash
# Links these dotfiles into $HOME. Existing files are moved to ~/.dotfiles-backup/<date>/.
# Run from the repo root after installing packages.txt and packages-aur.txt.
set -euo pipefail

DOTS="$(cd "$(dirname "$0")" && pwd)"
BACKUP="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"

link() {
  local src="$DOTS/$1" dst="$HOME/$1"
  mkdir -p "$(dirname "$dst")"
  if [ -L "$dst" ] && [ "$(readlink "$dst")" = "$src" ]; then
    return
  fi
  if [ -e "$dst" ] || [ -L "$dst" ]; then
    mkdir -p "$BACKUP/$(dirname "$1")"
    mv "$dst" "$BACKUP/$1"
    echo "backed up ~/$1"
  fi
  ln -s "$src" "$dst"
  echo "linked ~/$1"
}

for f in .zshenv .zshrc .zprofile .gtkrc-2.0 .icons/default/index.theme; do link "$f"; done
for d in "$DOTS"/.config/*/ ; do
  name="$(basename "$d")"
  case "$name" in
    gtk-2.0|gtk-3.0|gtk-4.0|Kvantum)
      # Linked per file: theme installers add their own files to these folders
      for f in "$d"*; do link ".config/$name/$(basename "$f")"; done ;;
    *) link ".config/$name" ;;
  esac
done
link .config/starship.toml
link .local/share/goodvibes/stations.xml

# Fonts are copied, not linked, so fontconfig picks them up reliably
mkdir -p "$HOME/.local/share/fonts"
cp --update=none "$DOTS"/.local/share/fonts/* "$HOME/.local/share/fonts/"
fc-cache -f

# Folders the configs expect
xdg-user-dirs-update
mkdir -p "$HOME/Pictures/Screenshots" "$HOME/Projects" "$HOME/org"

# Services
systemctl --user enable --now pipewire.socket pipewire-pulse.socket wireplumber.service
if systemctl is-enabled connman >/dev/null 2>&1; then
  echo "connman is enabled; disabling it in favour of NetworkManager"
  sudo systemctl disable --now connman
fi
sudo systemctl enable --now NetworkManager
sudo systemctl enable --now bluetooth power-profiles-daemon
systemctl --user enable gnome-keyring-daemon.socket

# Unlock the keyring with your login password (tty login, then niri)
if ! grep -q pam_gnome_keyring /etc/pam.d/login; then
  echo "Adding gnome-keyring to /etc/pam.d/login"
  printf 'auth       optional     pam_gnome_keyring.so\nsession    optional     pam_gnome_keyring.so auto_start\n' | sudo tee -a /etc/pam.d/login >/dev/null
fi

# Login shell
if [ "$(basename "$SHELL")" != "zsh" ]; then
  chsh -s /usr/bin/zsh
fi

echo
echo "Done. Backups (if any) are in $BACKUP"
echo "Next: put a wallpaper at ~/Pictures/wallpaper.png, then log out and log in on tty1."
