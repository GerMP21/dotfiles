#!/usr/bin/env bash
# Installs Doom Emacs and the Neovim plugins, treesitter parsers and language
# servers, using the configs setup-dotfiles.sh linked into ~/.config/doom and
# ~/.config/nvim. Doom is the slow part: it downloads and compiles its packages.
#
# Run install-packages.sh and setup-dotfiles.sh first. Safe to run again:
# an installed Doom gets doom sync instead of a new install.
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
for cmd in git emacs nvim make; do
  command -v "$cmd" >/dev/null || missing+=("$cmd")
done
if [ "${#missing[@]}" -gt 0 ]; then
  echo "Missing: ${missing[*]}. Run install-packages.sh first; nothing was changed." >&2
  exit 1
fi

for cfg in doom nvim; do
  if [ ! -e "$HOME/.config/$cfg" ]; then
    echo "~/.config/$cfg is missing. Run setup-dotfiles.sh first; nothing was changed." >&2
    exit 1
  fi
done

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

printf '\n\033[1;32mDone.\033[0m Run :checkhealth in nvim, and doom doctor if Emacs misbehaves.\n'
