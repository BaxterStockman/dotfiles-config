#!/usr/bin/env bash

# Files will be created with these permissions:
# files 644 -rw-r--r-- (666 minus 022)
# dirs  755 drwxr-xr-x (777 minus 022)
umask 022

# Fast directory switching
if [[ -r ~/.dotfiles/vendor/z/z.sh ]]; then
    export _Z_NO_PROMPT_COMMAND=1
    export _Z_DATA="${HOME}/.z/cache"
    mkdir -p "${_Z_DATA}"
    source ~/.dotfiles/vendor/z/z.sh
fi
