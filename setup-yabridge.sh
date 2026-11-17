#!/usr/bin/env bash
# Sets up yabridge (https://github.com/robbert-vdh/yabridge) so Windows VST3,
# VST2 and CLAP plugins work in Ardour and other Linux DAWs, through Wine.
#
#   1. Installs Wine Staging (with wine-mono and wine-gecko, so Wine doesn't
#      ask to download them), winetricks and realtime-privileges, and adds you
#      to the realtime group.
#   2. Installs yabridge's newest development build into
#      ~/.local/share/yabridge, and links yabridgectl into ~/.local/bin. The
#      5.1.1 release (Arch's yabridge package, part of the pro-audio group)
#      doesn't work with Wine 9.22 and newer: clicks in plugin windows don't
#      register. The fix is only in development builds so far, so that
#      package is removed to avoid a clash.
#   3. Creates the Wine prefix ~/.wine with the standard Windows plugin
#      folders, registers them with yabridgectl, and runs yabridgectl sync.
#
# Run as your normal user:  ~/dotfiles/setup-yabridge.sh
# Run it again to update yabridge to the newest development build.
#
# Afterwards, to add a Windows plugin:
#   wine ~/Downloads/PluginSetup.exe        (or: wine msiexec /i Plugin.msi)
#   yabridgectl sync
# then rescan plugins in Ardour (Window > Plugin Manager).
set -euo pipefail

step() { printf '\n\033[1;34m==> %s\033[0m\n' "$*"; }
warn() { printf '\033[1;33m!! %s\033[0m\n' "$*"; }
fail() { printf '\033[1;31mxx %s\033[0m\n' "$*" >&2; exit 1; }

if [ "$EUID" -eq 0 ]; then
  fail "Run this as your normal user, not root."
fi
command -v pacman >/dev/null || fail "This script is for CachyOS / Arch Linux (pacman not found)."
for tool in curl unzip tar; do
  command -v "$tool" >/dev/null || fail "$tool is missing: sudo pacman -S $tool"
done
# Wine needs 32-bit libraries from multilib, which CachyOS enables
grep -q '^\[multilib\]' /etc/pacman.conf || fail "The multilib repository isn't enabled in /etc/pacman.conf; Wine needs it."

USER_NAME="$(id -un)"
PREFIX="$HOME/.wine"
YB="$HOME/.local/share/yabridge"
YBCTL="$YB/yabridgectl"
BUILDS="https://nightly.link/robbert-vdh/yabridge/workflows/build/master"
RELOGIN=0

sudo -v

step "1/3 Wine and realtime privileges"
pkgs=(wine-staging wine-mono wine-gecko winetricks realtime-privileges)
if pacman -Qq wine >/dev/null 2>&1 && ! pacman -Qq wine-staging >/dev/null 2>&1; then
  echo "Wine Staging replaces the plain wine package: answer y when pacman asks to remove wine."
fi
sudo pacman -S --needed "${pkgs[@]}"
# Explicit, so it isn't removed as an orphan once Arch's yabridge (which
# pulled in Wine as a dependency) is gone
sudo pacman -D --asexplicit wine-staging >/dev/null
# Realtime scheduling and unlimited locked memory for audio: yabridge and
# Ardour both warn without it
groups_now="$(id -nG "$USER_NAME")"
if [[ " $groups_now " == *" realtime "* ]]; then
  echo "$USER_NAME is already in the realtime group"
else
  sudo gpasswd -a "$USER_NAME" realtime
  RELOGIN=1
fi

step "2/3 yabridge (newest development build)"
installed="$(pacman -Qq yabridge yabridgectl 2>/dev/null || true)"
if [ -n "$installed" ]; then
  warn "Removing Arch's yabridge 5.1.1 package ($(echo $installed)): it doesn't work with Wine 9.22+ and would clash with the development build"
  # shellcheck disable=SC2086  # one package name per word
  sudo pacman -R $installed
fi

page="$(curl -fsSL "$BUILDS")" || fail "Couldn't reach $BUILDS; check the network and run this again"
mapfile -t yb_zips < <(grep -oE 'yabridge-[0-9][^"/<]*\.tar\.gz\.zip' <<<"$page" | sort -u)
mapfile -t ctl_zips < <(grep -oE 'yabridgectl-[0-9][^"/<]*\.tar\.gz\.zip' <<<"$page" | sort -u)
[ "${#yb_zips[@]}" -eq 1 ] && [ "${#ctl_zips[@]}" -eq 1 ] \
  || fail "Couldn't find exactly one yabridge build on $BUILDS (the page may have changed)"
version="${yb_zips[0]#yabridge-}"
version="${version%.tar.gz.zip}"

if [ -x "$YBCTL" ] && [ "$(cat "$YB/.build" 2>/dev/null)" = "$version" ]; then
  echo "yabridge $version is already installed (the newest build)"
else
  tmp="$(mktemp -d)"
  trap 'rm -rf "$tmp"' EXIT
  echo "Downloading yabridge $version..."
  curl -fsSLo "$tmp/yabridge.zip" "$BUILDS/${yb_zips[0]}"
  curl -fsSLo "$tmp/yabridgectl.zip" "$BUILDS/${ctl_zips[0]}"
  # Each zip holds one tarball (GitHub wraps build files in a zip)
  unzip -p "$tmp/yabridge.zip" | tar -xz -C "$tmp"
  unzip -p "$tmp/yabridgectl.zip" | tar -xz -C "$tmp"
  [ -f "$tmp/yabridge/libyabridge-chainloader-vst3.so" ] && [ -f "$tmp/yabridgectl/yabridgectl" ] \
    || fail "The downloaded build doesn't contain the expected files"
  mkdir -p "$(dirname "$YB")"
  rm -rf "$YB"
  mv "$tmp/yabridge" "$YB"
  install -m 755 "$tmp/yabridgectl/yabridgectl" "$YBCTL"
  echo "$version" > "$YB/.build"
  echo "installed yabridge $version in ~/.local/share/yabridge"
fi
mkdir -p "$HOME/.local/bin"
ln -sfn "$YBCTL" "$HOME/.local/bin/yabridgectl"
"$YBCTL" set --path="$YB"

step "3/3 Wine prefix and plugin folders"
if [ ! -f "$PREFIX/system.reg" ]; then
  echo "Creating the Wine prefix $PREFIX (takes a minute)..."
  WINEPREFIX="$PREFIX" WINEDEBUG=-all wineboot -u
  WINEPREFIX="$PREFIX" wineserver -w
fi
# Where Windows installers put plugins by default
plugin_dirs=(
  "$PREFIX/drive_c/Program Files/Common Files/VST3"
  "$PREFIX/drive_c/Program Files/Common Files/CLAP"
  "$PREFIX/drive_c/Program Files/Steinberg/VstPlugins"
)
for d in "${plugin_dirs[@]}"; do
  mkdir -p "$d"
  "$YBCTL" add "$d"   # adding a folder twice is harmless
done
# Sets up every plugin found there in ~/.vst3/yabridge, ~/.vst/yabridge and
# ~/.clap/yabridge, which Ardour scans
"$YBCTL" sync

printf '\n\033[1;32mDone.\033[0m yabridge %s is set up.\n' "$version"
echo "To add a Windows plugin: run its installer with wine (keep the default folders), then yabridgectl sync,"
echo "then rescan plugins in Ardour (Window > Plugin Manager). yabridgectl status lists what's set up."
if [ "$RELOGIN" -eq 1 ]; then
  warn "You were added to the realtime group: reboot (or log out and in) before using Ardour, so it takes effect."
fi
