#!/usr/bin/env bash
# One-shot setup for these dotfiles on Arch Linux.
# Run as your normal user from anywhere:  ~/dotfiles/full-install.sh
# It asks for your sudo password when needed. It's safe to run again: finished steps are skipped or redone harmlessly.
set -euo pipefail

DOTS="$(cd "$(dirname "$0")" && pwd)"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

step() { printf '\n\033[1;34m==> %s\033[0m\n' "$*"; }
warn() { printf '\033[1;33m!! %s\033[0m\n' "$*"; }
pkglist() { grep -v '^\s*#' "$1" | grep -v '^\s*$'; }

if [ "$EUID" -eq 0 ]; then
  echo "Run this as your normal user, not root (makepkg refuses to run as root)." >&2
  exit 1
fi
if ! command -v pacman >/dev/null; then
  echo "This script is for Arch Linux (pacman not found)." >&2
  exit 1
fi

# Ask for sudo once up front and keep it alive while the script runs
sudo -v
while true; do sudo -n true; sleep 50; kill -0 "$$" 2>/dev/null || exit; done 2>/dev/null &

step "1/9 Official packages"
sudo pacman -Syu --needed --noconfirm git base-devel
mapfile -t PKGS < <(pkglist "$DOTS/packages.txt")
sudo pacman -S --needed "${PKGS[@]}"

step "2/9 AUR helper (paru)"
if command -v paru >/dev/null; then
  echo "paru already installed"
else
  git clone --depth 1 https://aur.archlinux.org/paru-bin.git "$TMP/paru-bin"
  (cd "$TMP/paru-bin" && makepkg -si --noconfirm)
fi

step "3/9 AUR packages"
mapfile -t AUR < <(pkglist "$DOTS/packages-aur.txt")
if ! paru -S --needed "${AUR[@]}"; then
  warn "Some AUR packages failed. Retrying them one by one."
  for p in "${AUR[@]}"; do
    paru -S --needed "$p" || warn "$p failed; install it later with: paru -S $p"
  done
fi

step "4/9 Link dotfiles"
"$DOTS/install.sh"

step "5/9 GTK theme, icons and cursor"
git clone --depth 1 https://github.com/Fausto-Korpsvart/Rose-Pine-GTK-Theme.git "$TMP/rose-pine-gtk"
(cd "$TMP/rose-pine-gtk/themes" && ./install.sh -c dark -l)
mkdir -p "$HOME/.local/share/icons"
rm -rf "$HOME/.local/share/icons/Rose-Pine-Moon"
cp -r "$TMP/rose-pine-gtk/icons/Rose-Pine-Moon" "$HOME/.local/share/icons/"
gtk-update-icon-cache -f "$HOME/.local/share/icons/Rose-Pine-Moon" || true

if ! ls /usr/share/icons/Sunity-cursors "$HOME/.icons/Sunity-cursors" >/dev/null 2>&1; then
  warn "Sunity cursors not found from the AUR; installing from GitHub"
  git clone --depth 1 https://github.com/alvatip/Sunity-cursors.git "$TMP/sunity"
  mkdir -p "$HOME/.icons"
  tar -xzf "$TMP/sunity/archives/Sunity-cursors.tar.gz" -C "$HOME/.icons/"
fi

if gsettings list-schemas 2>/dev/null | grep -q org.gnome.desktop.interface; then
  gsettings set org.gnome.desktop.interface gtk-theme 'Rosepine-Dark'
  gsettings set org.gnome.desktop.interface icon-theme 'Rose-Pine-Moon'
  gsettings set org.gnome.desktop.interface cursor-theme 'Sunity-cursors'
  gsettings set org.gnome.desktop.interface cursor-size 24
  gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
else
  warn "gsettings schema missing; set the theme later in nwg-look"
fi

step "6/9 Doom Emacs"
if [ -x "$HOME/.config/emacs/bin/doom" ]; then
  "$HOME/.config/emacs/bin/doom" sync
else
  git clone --depth 1 https://github.com/doomemacs/doomemacs "$HOME/.config/emacs"
  # --force answers yes to the prompts (envvar file, fonts)
  "$HOME/.config/emacs/bin/doom" install --force
fi
"$HOME/.config/emacs/bin/doom" doctor || warn "doom doctor reported issues; review them above"

step "7/9 Neovim plugins, parsers and language servers"
nvim --headless "+Lazy! sync" +qa || warn "lazy.nvim sync failed; open nvim to retry"
echo "Mason installs the language servers the first time you open nvim."

step "8/9 Wallpaper"
if [ ! -f "$HOME/Pictures/wallpaper.png" ]; then
  warn "No ~/Pictures/wallpaper.png yet; swaybg shows nothing until you add one."
fi

step "9/9 Check the niri config"
niri validate || warn "niri validate failed; fix ~/.config/niri/config.kdl before logging in"

printf '\n\033[1;32mDone.\033[0m Log out and log in on tty1 to start niri.\n'
echo "Then run :checkhealth in nvim, and 'niri msg outputs' to set up monitors."
