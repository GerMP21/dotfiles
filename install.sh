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

for f in .zshrc .zprofile .gtkrc-2.0 .icons/default/index.theme; do link "$f"; done
for d in "$DOTS"/.config/*/ ; do link ".config/$(basename "$d")"; done
link .config/starship.toml
link .local/share/goodvibes/stations.xml

# Fonts are copied, not linked, so fontconfig picks them up reliably
mkdir -p "$HOME/.local/share/fonts"
cp -n "$DOTS"/.local/share/fonts/* "$HOME/.local/share/fonts/"
fc-cache -f

# Folders the configs expect
xdg-user-dirs-update
mkdir -p "$HOME/Pictures/Screenshots" "$HOME/Projects" "$HOME/org"

# Put the real home path in the wallpaper line
sed -i "s|/home/USERNAME/|$HOME/|" "$DOTS/.config/niri/config.kdl"

# Services
systemctl --user enable --now pipewire pipewire-pulse wireplumber
if systemctl is-enabled connman >/dev/null 2>&1; then
  echo "connman is enabled; disabling it in favour of NetworkManager"
  sudo systemctl disable --now connman
fi
sudo systemctl enable --now NetworkManager

# Login shell
if [ "$(basename "$SHELL")" != "zsh" ]; then
  chsh -s /usr/bin/zsh
fi

echo
echo "Done. Backups (if any) are in $BACKUP"
echo "Next: put a wallpaper at ~/Pictures/wallpaper.png, then log out and log in on tty1."
