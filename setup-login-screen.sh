#!/usr/bin/env bash
# Optional: sets up the SDDM login screen with the Tokyo Night theme from
# system/sddm/, your background and your profile picture.
#
#   ./setup-login-screen.sh                       repo images (system/sddm/)
#   ./setup-login-screen.sh --background FILE --avatar FILE
#                                                 your own images instead
#
# Unlike the other scripts, this writes outside your home folder (with sudo):
#   /usr/share/sddm/themes/tokyo-night-dotfiles/   the theme and background
#   /usr/share/sddm/faces/<you>.face.icon          your profile picture
#   /etc/sddm.conf.d/10-dotfiles-theme.conf        selects the theme
# To undo: sudo rm /etc/sddm.conf.d/10-dotfiles-theme.conf
# Safe to run again.
set -euo pipefail

DOTS="$(cd "$(dirname "$0")" && pwd)"
THEME_SRC="$DOTS/system/sddm/tokyo-night"
THEME_NAME="tokyo-night-dotfiles"
THEME_DIR="/usr/share/sddm/themes/$THEME_NAME"
DROPIN="/etc/sddm.conf.d/10-dotfiles-theme.conf"
background="$THEME_SRC/background.jpg"
avatar="$DOTS/system/sddm/avatar.jpg"

warn() { printf '\033[1;33m!! %s\033[0m\n' "$*"; }
usage() { sed -n '2,15p' "$0" | sed 's/^# \{0,1\}//'; }

while [ $# -gt 0 ]; do
  case "$1" in
    --background) background="${2:?--background needs a file}"; shift 2 ;;
    --avatar)     avatar="${2:?--avatar needs a file}"; shift 2 ;;
    -h|--help)    usage; exit 0 ;;
    *)            usage >&2; exit 1 ;;
  esac
done

if [ "$EUID" -eq 0 ]; then
  echo "Run this as your normal user (it uses sudo itself), so the picture goes to your account." >&2
  exit 1
fi
for f in "$background" "$avatar"; do
  [ -f "$f" ] || { echo "Image not found: $f" >&2; exit 1; }
done
if ! command -v sddm >/dev/null; then
  echo "SDDM isn't installed; this is for CachyOS's niri desktop, which uses it." >&2
  exit 1
fi
if ! command -v sddm-greeter-qt6 >/dev/null; then
  warn "sddm-greeter-qt6 not found; this theme needs SDDM 0.21+ with Qt 6"
fi

user="$(id -un)"
sudo -v

# Theme, with the background copied in under its own name
sudo install -d -m 755 "$THEME_DIR"
sudo install -m 644 "$THEME_SRC/Main.qml" "$THEME_SRC/metadata.desktop" "$THEME_SRC/theme.conf" "$THEME_DIR/"
ext="${background##*.}"
sudo install -m 644 "$background" "$THEME_DIR/background.$ext"
# theme.conf.user overrides theme.conf, so a non-jpg background still works
printf '[General]\nbackground=background.%s\n' "$ext" | sudo tee "$THEME_DIR/theme.conf.user" >/dev/null
echo "installed the theme in $THEME_DIR"

# Profile picture: SDDM checks this folder first. It can't read your home
# (CachyOS makes it private), so ~/.face.icon wouldn't work.
sudo install -d -m 755 /usr/share/sddm/faces
sudo install -m 644 "$avatar" "/usr/share/sddm/faces/$user.face.icon"
echo "installed your profile picture for $user"

# Select the theme with a drop-in, leaving /etc/sddm.conf alone
sudo install -d -m 755 /etc/sddm.conf.d
printf '# From ~/dotfiles/setup-login-screen.sh. Delete this file to undo.\n[Theme]\nCurrent=%s\n' "$THEME_NAME" \
  | sudo tee "$DROPIN" >/dev/null
echo "selected the theme in $DROPIN"

# /etc/sddm.conf is read last, so a Current= there would win over the drop-in
if [ -f /etc/sddm.conf ] && sudo grep -qE '^\s*Current\s*=' /etc/sddm.conf; then
  warn "/etc/sddm.conf sets its own theme ($(sudo grep -E '^\s*Current\s*=' /etc/sddm.conf | head -1 | tr -d ' ')), which overrides this one."
  warn "Remove that line with: sudo sed -i '/^\\s*Current\\s*=/d' /etc/sddm.conf"
fi

printf '\n\033[1;32mDone.\033[0m Preview it without logging out:\n'
echo "  sddm-greeter-qt6 --test-mode --theme $THEME_DIR"
echo "The real login screen changes the next time SDDM starts (log out or reboot)."
