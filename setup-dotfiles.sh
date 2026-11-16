#!/usr/bin/env bash
# Puts these dotfiles in place. Run install-packages.sh first.
#
#   ./setup-dotfiles.sh                  Link the configs into ~, copy the fonts,
#                                        install the GTK/Qt/icon/cursor themes, then
#                                        finish the setup: services, zsh as login
#                                        shell, Doom Emacs and Neovim plugins.
#   ./setup-dotfiles.sh --preview [DIR]  Copy everything that would be linked or
#                                        copied into ~ to DIR instead (default:
#                                        preview/ in this repo), with a list in
#                                        DIR/MANIFEST.txt. Changes nothing else.
#
# Files a real run replaces are moved to ~/.dotfiles-backup/<date>/ first.
# Safe to run again.
set -euo pipefail

DOTS="$(cd "$(dirname "$0")" && pwd)"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

step() { printf '\n\033[1;34m==> %s\033[0m\n' "$*"; }
warn() { printf '\033[1;33m!! %s\033[0m\n' "$*"; }
usage() { sed -n '2,14p' "$0" | sed 's/^# \{0,1\}//'; }

PREVIEW=0
ROOT="$HOME"
case "${1:-}" in
  "") ;;
  --preview)
    PREVIEW=1
    ROOT="$(realpath -m "${2:-$DOTS/preview}")" ;;
  -h|--help) usage; exit 0 ;;
  *) usage >&2; exit 1 ;;
esac

if [ "$EUID" -eq 0 ]; then
  echo "Run this as your normal user, not root." >&2
  exit 1
fi

if [ "$PREVIEW" -eq 1 ]; then
  if [ "$ROOT" = "$(realpath -m "$HOME")" ]; then
    echo "The preview folder can't be your home folder." >&2
    exit 1
  fi
  # Only reuse a folder that an earlier preview made
  if [ -e "$ROOT" ]; then
    if [ -f "$ROOT/MANIFEST.txt" ]; then
      rm -rf "$ROOT"
    elif [ -n "$(ls -A "$ROOT")" ]; then
      echo "$ROOT exists and isn't an earlier preview; pick an empty or new folder." >&2
      exit 1
    fi
  fi
  mkdir -p "$ROOT"
  MANIFEST="$ROOT/MANIFEST.txt"
  {
    echo "Preview of setup-dotfiles.sh, made $(date '+%Y-%m-%d %H:%M')."
    echo "Each file below sits in this folder where it would sit in your home folder."
    echo "link     = a real run makes a symlink into $DOTS"
    echo "copy     = a real run copies the file (fonts; existing ones are kept)"
    echo "download = a real run downloads and installs it (themes)"
    echo
  } > "$MANIFEST"
else
  BACKUP="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"
fi

note() { [ "$PREVIEW" -eq 1 ] && printf '%-9s ~/%s\n' "$1" "$2" >> "$MANIFEST"; return 0; }

# put <link|copy> <path>: the path is the same in the repo and under ~
put() {
  local how="$1" rel="$2" src="$DOTS/$2" dst="$ROOT/$2"
  mkdir -p "$(dirname "$dst")"
  if [ "$PREVIEW" -eq 1 ]; then
    cp -rL "$src" "$dst"
    note "$how" "$rel"
    return
  fi
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

if [ "$PREVIEW" -eq 1 ]; then
  step "Preview: copying everything into $ROOT"
fi

step "Configs"
for f in .zshenv .zshrc .zprofile .gtkrc-2.0 .icons/default/index.theme; do put link "$f"; done
for d in "$DOTS"/.config/*/; do
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

step "Fonts"
# Copied, not linked, so fontconfig picks them up reliably
for f in "$DOTS"/.local/share/fonts/*; do put copy ".local/share/fonts/$(basename "$f")"; done

step "GTK and Qt themes, icons and cursor"
# GTK theme and icons: Fausto-Korpsvart/Rose-Pine-GTK-Theme. Its installer
# uses $HOME, so a preview points it at the preview folder.
if git clone -q --depth 1 https://github.com/Fausto-Korpsvart/Rose-Pine-GTK-Theme.git "$TMP/rose-pine-gtk" \
  && (cd "$TMP/rose-pine-gtk/themes" && HOME="$ROOT" ./install.sh -c dark -l -d "$ROOT/.themes" >/dev/null); then
  mkdir -p "$ROOT/.local/share/icons"
  rm -rf "$ROOT/.local/share/icons/Rose-Pine-Moon"
  cp -r "$TMP/rose-pine-gtk/icons/Rose-Pine-Moon" "$ROOT/.local/share/icons/"
  gtk-update-icon-cache -f "$ROOT/.local/share/icons/Rose-Pine-Moon" >/dev/null 2>&1 || true
  echo "installed Rosepine-Dark and Rose-Pine-Moon"
  note download ".themes/Rosepine-Dark (GTK theme)"
  note download ".config/gtk-4.0/{assets,gtk.css,gtk-dark.css} (GTK 4 theme links)"
  note download ".local/share/icons/Rose-Pine-Moon (icon theme)"
else
  warn "Rose Pine GTK theme failed (it needs git and sassc); run this script again later"
fi

# Cursor: from the AUR package sunity-cursors-git, else from GitHub
if ! ls /usr/share/icons/Sunity-cursors "$ROOT/.icons/Sunity-cursors" >/dev/null 2>&1; then
  if git clone -q --depth 1 https://github.com/alvatip/Sunity-cursors.git "$TMP/sunity"; then
    mkdir -p "$ROOT/.icons"
    tar -xzf "$TMP/sunity/archives/Sunity-cursors.tar.gz" -C "$ROOT/.icons/"
    echo "installed Sunity-cursors"
    note download ".icons/Sunity-cursors (cursor theme; a real run skips it when sunity-cursors-git is installed)"
  else
    warn "Sunity cursors failed to download; run this script again later"
  fi
fi

# Qt: Rose Pine theme for Kvantum (rose-pine/kvantum)
if git clone -q --depth 1 https://github.com/rose-pine/kvantum.git "$TMP/rose-pine-kvantum"; then
  mkdir -p "$ROOT/.config/Kvantum"
  rm -rf "$ROOT/.config/Kvantum/rose-pine-foam"
  tar -xzf "$TMP/rose-pine-kvantum/dist/rose-pine-foam.tar.gz" -C "$ROOT/.config/Kvantum/"
  echo "installed rose-pine-foam for Kvantum"
  note download ".config/Kvantum/rose-pine-foam (Qt theme)"
else
  warn "Rose Pine Kvantum theme failed to download; run this script again later"
fi

if [ "$PREVIEW" -eq 1 ]; then
  {
    echo
    echo "A real run also does these, which a preview skips:"
    echo "- moves files it replaces to ~/.dotfiles-backup/<date>/"
    echo "- refreshes the font cache and creates ~/Pictures/Screenshots, ~/Projects and ~/org"
    echo "- applies the GTK theme, icons, cursor and dark mode with gsettings"
    echo "- enables power-profiles-daemon and the GNOME keyring socket"
    echo "- makes zsh your login shell"
    echo "- installs Doom Emacs into ~/.config/emacs and the Neovim plugins"
    echo "- checks the niri and Noctalia configs"
  } >> "$MANIFEST"
  printf '\n\033[1;32mPreview ready:\033[0m %s\n' "$ROOT"
  echo "Start with $MANIFEST. Nothing in your home folder changed."
  echo "Look at hidden files with: ls -la $ROOT"
  exit 0
fi

step "Folders, font cache and theme settings"
fc-cache -f
xdg-user-dirs-update
mkdir -p "$HOME/Pictures/Screenshots" "$HOME/Projects" "$HOME/org"
# GTK 4 / libadwaita apps ignore settings.ini on Wayland
if gsettings list-schemas 2>/dev/null | grep -q org.gnome.desktop.interface; then
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
sudo systemctl enable --now power-profiles-daemon
systemctl --user enable gnome-keyring-daemon.socket
# CachyOS makes fish the default
if [ "$(basename "$SHELL")" != "zsh" ]; then
  chsh -s /usr/bin/zsh
fi

step "Doom Emacs"
if [ -x "$HOME/.config/emacs/bin/doom" ]; then
  "$HOME/.config/emacs/bin/doom" sync
else
  git clone --depth 1 https://github.com/doomemacs/doomemacs "$HOME/.config/emacs"
  # --env generates the envvar file; --force answers yes to any other prompt
  "$HOME/.config/emacs/bin/doom" install --env --force
fi
"$HOME/.config/emacs/bin/doom" doctor || warn "doom doctor reported issues; review them above"

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
