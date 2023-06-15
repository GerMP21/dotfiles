# .bashrc

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias cl='clear'
alias ls='ls --color=auto'
alias la='ls -A --color=auto'
alias nv='nvim'
alias g='git'
alias xi='sudo xbps-install'
alias xr='sudo xbps-remove':
alias xq='xbps-query'
alias xs='$HOME/.local/pkgs/void-packages/xbps-src'
alias fp='sudo flatpak'
alias crawl='crawl-tiles'

eval "$(starship init bash)"
