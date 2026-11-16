#!/usr/bin/env bash
# Installs the packages these dotfiles need on CachyOS with the niri desktop:
# packages.txt from the repos with pacman (paru and pipx included),
# packages-aur.txt from the AUR with paru, then packages-pipx.txt with pipx.
# pipx installs into ~/.local/bin, which .zshenv puts on PATH.
#
# Run as your normal user:  ~/dotfiles/install-packages.sh
# It asks for your sudo password. Safe to run again: what's installed is skipped.
# Then run setup-dotfiles.sh, setup-desktop.sh and setup-editors.sh.
set -euo pipefail

DOTS="$(cd "$(dirname "$0")" && pwd)"

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

# Ask for sudo once up front and keep it alive while AUR packages build
sudo -v
while true; do sudo -n true; sleep 50; kill -0 "$$" 2>/dev/null || exit; done 2>/dev/null &

step "1/3 Repo packages (including paru and pipx)"
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

step "2/3 AUR packages"
mapfile -t AUR < <(pkglist "$DOTS/packages-aur.txt")
if ! paru -S --needed "${AUR[@]}"; then
  warn "Some AUR packages failed. Retrying them one by one."
  for p in "${AUR[@]}"; do
    paru -S --needed "$p" || warn "$p failed; install it later with: paru -S $p"
  done
fi

step "3/3 Python tools (pipx)"
mapfile -t PIPX < <(pkglist "$DOTS/packages-pipx.txt")
# Saved first: with pipefail, a pipe into grep -q can fail even on a match
pipx_list="$(pipx list --short 2>/dev/null || true)"
for p in "${PIPX[@]}"; do
  if grep -q "^$p " <<<"$pipx_list"; then
    echo "$p already installed (update with: pipx upgrade $p)"
  else
    pipx install "$p" || warn "$p failed; install it later with: pipx install $p"
  fi
done

printf '\n\033[1;32mDone.\033[0m Next: %s/setup-dotfiles.sh, then setup-desktop.sh and setup-editors.sh.\n' "$DOTS"
