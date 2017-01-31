#!/usr/bin/env bash

# Bash won't get SIGWINCH if another process is in the foreground.
# Enable checkwinsize so that bash will check the terminal size when
# it regains control.
# http://cnswww.cns.cwru.edu/~chet/bash/FAQ (E11)
shopt -s checkwinsize

# Enable extended globbing
shopt -s extglob

# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob

# Color grep results
# XXX DEPRECATED
#export GREP_OPTIONS='--color=auto'
alias grep='grep --color=auto'

# Prevent less from clearing the screen while still showing colors.
export LESS=-XR

# Page with vimpager
if exists vimpager; then
    export PAGER=vimpager
else
    export PAGER=less
fi

# set editing mode to 'vi'
set -o vi

## Manual tab completion
complete -cf sudo
complete -cf man

# SSH auto-completion based on entries in known_hosts.
if [[ -e ~/.ssh/known_hosts ]]; then
  complete -o default -W "$(sed 's/[, ].*//' < "${HOME}/.ssh/known_hosts" | sort | uniq | grep -v '[0-9]')" ssh scp sftp rsync
fi
