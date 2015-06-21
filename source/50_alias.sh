#!/usr/bin/env bash

## Modified commands
alias less="\$PAGER"
alias more="\$PAGER"
alias df='df -h'
alias du='du -c -h'
alias mkdir='mkdir -p -v'
alias nano='nano -w'
alias ping='ping -c 5'
alias dmesg='dmesg -HL'

## Privileged access
if [[ $UID -ne 0 ]]; then
    alias sudo='sudo '
    alias scat='sudo cat'
    alias svim='sudoedit'
    alias root='sudo -s'
fi

## ls
# Always use color output for `ls`
if [[ "$OSTYPE" =~ ^(darwin|freebsd) ]]; then
    alias ls="command ls -hFG"
else
    alias ls='ls -hF --color=auto'
fi

# Directory listing
if [[ "$(type -P tree)" ]]; then
    alias ll='tree --dirsfirst -aLpughDFiC 1'
    alias lsd='ll -d'
else
    alias ll='ls -al'
    alias lsd='CLICOLOR_FORCE=1 ll | grep --color=never "^d"'
fi

alias lr='ls -R'                    # recursive ls
alias la='ll -a'
alias lx='ll -BX'                   # sort by extension
alias lz='ll -rS'                   # sort by size
alias lt='ll -rt'                   # sort by date
alias lm='la | more'

# Easier navigation: .., ..., -
alias ..='cd ..'
alias ...='cd ../..'
alias -- -='cd -'

# File size
alias fs="stat -f '%z bytes'"
alias df="df -h"

# Recursively delete `.DS_Store` files
alias dsstore="find . -name '*.DS_Store' -type f -ls -delete"

# Aliasing eachdir like this allows you to use aliases/functions as commands.
alias eachdir=". eachdir"

# Safety features
alias cp='cp -i'
alias mv='mv -i'
exists trash-put && alias rm='echo "Try trash-put instead."; false'
#alias rm='rm -I'                    # 'rm -i' prompts for every file
# safer alternative w/ timeout, not stored in history
alias rm=' timeout 3 rm -Iv --one-file-system'
alias ln='ln -i'
alias cls=' echo -ne "\033c"'       # clear screen for real (it does not work in Terminology)
# Hopefully won't have to use this too often...
alias shred=' timeout 3 shred -v'


# Make Bash error tolerant
alias :w=' echo "Come again?" ; :'
alias :q=' exit'
alias :Q=' exit'
alias :x=' exit'
alias cd..='cd ..'

# Assorted other aliases
alias chkrun='top -b | grep'
alias tp='trash-put'
alias tl='trash-list'
alias te='trash-empty'

# VirtualBox Manager
alias vbm="VBoxManage"
alias virtualboxmanage="vboxmanage"

# WM-related stuff
alias rp='ratpoison'

# Alias urxvtc to urxvt if the system has urxvtd and urxvtc
alias urxvt='urxvtc'

# Make xrdb search for includes in $HOME/.Xresources.d
alias xrdb="xrdb -I\${HOME}/.Xresources.d"
