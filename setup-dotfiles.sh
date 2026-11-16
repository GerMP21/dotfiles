#!/usr/bin/env bash
# Links the dotfiles into ~ and copies the fonts. Nothing else: no downloads,
# no services, no sudo. setup-desktop.sh and setup-editors.sh do the rest.
#
# Everything it links or copies is in home/ in this repo, laid out the same
# way as in ~: home/.config/niri becomes ~/.config/niri. Files it replaces are
# moved to ~/.dotfiles-backup/<date>/ first. Safe to run again.
set -euo pipefail

DOTS="$(cd "$(dirname "$0")" && pwd)"

step() { printf '\n\033[1;34m==> %s\033[0m\n' "$*"; }
warn() { printf '\033[1;33m!! %s\033[0m\n' "$*"; }

if [ "$EUID" -eq 0 ]; then
  echo "Run this as your normal user, not root." >&2
  exit 1
fi

SRC="$DOTS/home"
BACKUP="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"

# put <link|copy> <path>: the path is the same under home/ and under ~
put() {
  local how="$1" rel="$2" src="$SRC/$2" dst="$HOME/$2"
  mkdir -p "$(dirname "$dst")"
  if [ "$how" = copy ]; then
    if [ ! -e "$dst" ]; then cp "$src" "$dst"; echo "copied ~/$rel"; fi
    return
  fi
  if [ -L "$dst" ] && [ "$(readlink "$dst")" = "$src" ]; then
    return
  fi
  if [ -e "$dst" ] || [ -L "$dst" ]; then
    mkdir -p "$BACKUP/$(dirname "$rel")"
    mv "$dst" "$BACKUP/$rel"
    echo "backed up ~/$rel"
  fi
  ln -s "$src" "$dst"
  echo "linked ~/$rel"
}

step "Configs"
for f in .zshenv .zshrc .zprofile .gtkrc-2.0 .icons/default/index.theme; do put link "$f"; done
for d in "$SRC"/.config/*/; do
  name="$(basename "$d")"
  case "$name" in
    gtk-2.0|gtk-3.0|gtk-4.0|Kvantum|xdg-desktop-portal)
      # Linked per file: theme installers and apps add their own files here
      for f in "$d"*; do put link ".config/$name/$(basename "$f")"; done ;;
    *) put link ".config/$name" ;;
  esac
done
put link .config/starship.toml
put link .local/share/goodvibes/stations.xml
put link .local/share/backgrounds/wallpaper.jpg
put link .local/bin/keybinds

step "Fonts"
# Copied, not linked, so fontconfig picks them up reliably
for f in "$SRC"/.local/share/fonts/*; do put copy ".local/share/fonts/$(basename "$f")"; done
command -v fc-cache >/dev/null && fc-cache -f

printf '\n\033[1;32mDone.\033[0m Backups (if any) are in %s\n' "$BACKUP"
echo "Next: $DOTS/setup-desktop.sh (themes, services, login shell) and $DOTS/setup-editors.sh (Doom Emacs, Neovim)."
