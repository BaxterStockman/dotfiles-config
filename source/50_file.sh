#!/usr/bin/env bash

# Files will be created with these permissions:
# files 644 -rw-r--r-- (666 minus 022)
# dirs  755 drwxr-xr-x (777 minus 022)
umask 022

# Fast directory switching
export _Z_NO_PROMPT_COMMAND=1
export _Z_DATA="${DOTFILES_CACHES_PATH}/.z"
source ~/.dotfiles/vendor/z/z.sh
