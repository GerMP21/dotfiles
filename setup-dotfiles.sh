#!/usr/bin/env bash
# Puts these dotfiles in place. Run install-packages.sh first.
#
# Everything this script links or copies into ~ is in home/ in this repo,
# laid out the same way as in ~: home/.config/niri becomes ~/.config/niri.
# It links the configs, copies the fonts, installs the GTK/Qt/icon/cursor
# themes, then enables two services, makes zsh your login shell, and
# installs Doom Emacs and the Neovim plugins.
#
# Files it replaces are moved to ~/.dotfiles-backup/<date>/ first.
# Safe to run again.
set -euo pipefail

DOTS="$(cd "$(dirname "$0")" && pwd)"
SRC="$DOTS/home"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

step() { printf '\n\033[1;34m==> %s\033[0m\n' "$*"; }
warn() { printf '\033[1;33m!! %s\033[0m\n' "$*"; }

if [ "$EUID" -eq 0 ]; then
  echo "Run this as your normal user, not root." >&2
  exit 1
fi

# Stop before changing anything if the packages aren't installed yet
missing=()
for cmd in git zsh nvim emacs niri noctalia fc-cache; do
  command -v "$cmd" >/dev/null || missing+=("$cmd")
done
if [ "${#missing[@]}" -gt 0 ]; then
  echo "Missing: ${missing[*]}. Run install-packages.sh first; nothing was changed." >&2
  exit 1
fi

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

step "Folders, font cache and theme settings"
fc-cache -f
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

step "Doom Emacs"
if [ -x "$HOME/.config/emacs/bin/doom" ]; then
  "$HOME/.config/emacs/bin/doom" sync || warn "doom sync failed; run it later: doom sync"
elif [ -e "$HOME/.config/emacs" ]; then
  warn "~/.config/emacs exists but isn't Doom Emacs; left alone, so Doom isn't installed"
elif git clone --depth 1 https://github.com/doomemacs/doomemacs "$HOME/.config/emacs"; then
  # --env generates the envvar file; --force answers yes to any other prompt
  "$HOME/.config/emacs/bin/doom" install --env --force || warn "doom install failed; run it later: ~/.config/emacs/bin/doom install --env"
else
  warn "Doom Emacs failed to download; run this script again later"
fi
if [ -x "$HOME/.config/emacs/bin/doom" ]; then
  "$HOME/.config/emacs/bin/doom" doctor || warn "doom doctor reported issues; review them above"
fi

step "Neovim plugins, parsers and language servers"
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

step "Check the niri and Noctalia configs"
niri validate || warn "niri validate failed; fix ~/.config/niri/config.kdl before logging in"
noctalia config validate || warn "noctalia config validate failed; fix ~/.config/noctalia/config.toml"

printf '\n\033[1;32mDone.\033[0m Backups (if any) are in %s\n' "$BACKUP"
echo "Log out, then log back in from the login screen with the niri session."
echo "Then run :checkhealth in nvim, and 'niri msg outputs' to set up monitors."
