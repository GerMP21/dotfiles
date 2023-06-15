# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000
bindkey -v
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/german/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

alias cl='clear'
alias ls='ls --color=auto'
alias la='ls -A --color=auto'
alias nv='nvim'
alias g='git'
alias xi='sudo xbps-install'
alias xr='sudo xbps-remove'
alias xq='xbps-query'
alias xs='$HOME/.local/pkgs/void-packages/xbps-src'
alias fp='sudo flatpak'
alias crawl='crawl-tiles'

source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

eval "$(starship init zsh)"

neofetch
