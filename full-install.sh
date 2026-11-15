#!/usr/bin/env bash
# One-shot setup for these dotfiles on CachyOS, installed with the niri desktop.
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
  echo "This script is for CachyOS / Arch Linux (pacman not found)." >&2
  exit 1
fi

# Ask for sudo once up front and keep it alive while the script runs
sudo -v
while true; do sudo -n true; sleep 50; kill -0 "$$" 2>/dev/null || exit; done 2>/dev/null &

step "1/8 Repo packages (including paru)"
sudo pacman -Syu
# Skip names that aren't in the repos (e.g. moved to the AUR) instead
# of letting one unknown name make pacman refuse the whole list
mapfile -t WANTED < <(pkglist "$DOTS/packages.txt" | sort -u)
mapfile -t MISSING < <(comm -23 <(printf '%s\n' "${WANTED[@]}") <(pacman -Slq | sort -u))
mapfile -t PKGS < <(comm -12 <(printf '%s\n' "${WANTED[@]}") <(pacman -Slq | sort -u))
if [ "${#MISSING[@]}" -gt 0 ]; then
  warn "Not in the repos, skipped: ${MISSING[*]}"
  warn "They may have moved to the AUR; try: paru -S ${MISSING[*]}"
fi
sudo pacman -S --needed "${PKGS[@]}"

step "2/8 AUR packages"
mapfile -t AUR < <(pkglist "$DOTS/packages-aur.txt")
if ! paru -S --needed "${AUR[@]}"; then
  warn "Some AUR packages failed. Retrying them one by one."
  for p in "${AUR[@]}"; do
    paru -S --needed "$p" || warn "$p failed; install it later with: paru -S $p"
  done
fi

step "3/8 Link dotfiles"
"$DOTS/install.sh"

step "4/8 GTK and Qt themes, icons and cursor"
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

# Qt: Rose Pine theme for Kvantum (official rose-pine/kvantum)
git clone --depth 1 https://github.com/rose-pine/kvantum.git "$TMP/rose-pine-kvantum"
mkdir -p "$HOME/.config/Kvantum"
rm -rf "$HOME/.config/Kvantum/rose-pine-foam"
tar -xzf "$TMP/rose-pine-kvantum/dist/rose-pine-foam.tar.gz" -C "$HOME/.config/Kvantum/"

if gsettings list-schemas 2>/dev/null | grep -q org.gnome.desktop.interface; then
  gsettings set org.gnome.desktop.interface gtk-theme 'Rosepine-Dark'
  gsettings set org.gnome.desktop.interface icon-theme 'Rose-Pine-Moon'
  gsettings set org.gnome.desktop.interface cursor-theme 'Sunity-cursors'
  gsettings set org.gnome.desktop.interface cursor-size 24
  gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
else
  warn "gsettings schema missing; set the theme later in nwg-look"
fi

step "5/8 Doom Emacs"
if [ -x "$HOME/.config/emacs/bin/doom" ]; then
  "$HOME/.config/emacs/bin/doom" sync
else
  git clone --depth 1 https://github.com/doomemacs/doomemacs "$HOME/.config/emacs"
  # --env generates the envvar file; --force answers yes to any other prompt
  "$HOME/.config/emacs/bin/doom" install --env --force
fi
"$HOME/.config/emacs/bin/doom" doctor || warn "doom doctor reported issues; review them above"

step "6/8 Neovim plugins, parsers and language servers"
nvim --headless "+Lazy! sync" +qa || warn "lazy.nvim sync failed; open nvim to retry"
# Telescope's fzf extension is a C library that lazy.nvim builds with make;
# build it here if that didn't happen, so Telescope gets the fast sorter
FZF="${XDG_DATA_HOME:-$HOME/.local/share}/nvim/lazy/telescope-fzf-native.nvim"
if [ -d "$FZF" ] && [ ! -f "$FZF/build/libfzf.so" ]; then
  make -C "$FZF" || warn "telescope-fzf-native failed to build; run: make -C $FZF"
fi
# Both of these block until done when nvim runs headless
nvim --headless --cmd "let g:bootstrap=1" -c "lua require('nvim-treesitter').install(require('plugins.config.ts_parsers')):wait(600000)" -c qa \
  || warn "Treesitter parsers failed; run :TSUpdate in nvim"
nvim --headless --cmd "let g:bootstrap=1" -c "MasonInstall bash-language-server python-lsp-server typescript-language-server rust-analyzer lua-language-server" -c qa \
  || warn "Some language servers failed; run :Mason in nvim"

step "7/8 Wallpaper"
if [ ! -f "$HOME/.local/share/backgrounds/wallpaper.jpg" ]; then
  warn "Wallpaper missing at ~/.local/share/backgrounds/wallpaper.jpg; re-run install.sh."
fi

step "8/8 Check the niri and Noctalia configs"
niri validate || warn "niri validate failed; fix ~/.config/niri/config.kdl before logging in"
noctalia config validate || warn "noctalia config validate failed; fix ~/.config/noctalia/config.toml"

printf '\n\033[1;32mDone.\033[0m Log out, then log back in from the login screen with the niri session.\n'
echo "Then run :checkhealth in nvim, and 'niri msg outputs' to set up monitors."
