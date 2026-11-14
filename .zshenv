# Environment for every zsh (login, interactive and scripts).
# niri inherits this from the tty1 login shell, so apps launched from
# fuzzel or keybinds see the same PATH and EDITOR as your terminal.
typeset -U path PATH   # no duplicate PATH entries

export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"

export EDITOR="nvim"
export VISUAL="nvim"
export MANPAGER="nvim +Man!"

export PYENV_ROOT="$HOME/.pyenv"

path=(
  "$HOME/.bin"
  "$HOME/.local/bin"
  "$HOME/Applications"
  "$HOME/.config/emacs/bin"
  "$PYENV_ROOT/bin"
  "/var/lib/flatpak/exports/bin"
  $path
)
# Drop the ones that don't exist
path=(${^path}(N-/))
export PATH
