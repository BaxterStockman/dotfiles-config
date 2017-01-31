#!/usr/bin/env bash

# Check that we're on Arch
[[ "$(< /etc/issue)" =~ Arch ]] || return 1

# Other aliases
alias cower='cower --color=auto'
alias packauto='packer --noedit --noconfirm'
alias packquery=' pacman -Q | grep'

## Privileged access
if [ $UID -ne 0 ]; then
    alias_if reboot='sudo systemctl reboot'
    alias_if poweroff='sudo systemctl poweroff'
    alias_if update='sudo pacman -Su'
    alias_if netctl='sudo netctl'
fi

# Odds and ends
if [[ "$(pgrep rxvt | wc -l)" -ge 1 ]] && exists archey3; then
    archey3
fi
