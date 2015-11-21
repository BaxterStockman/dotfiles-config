#!/usr/bin/env bash

header='Processing optional configuration'

pre () {
    __DOTFILES_ROOT="${DOTFILES_ROOT-}"
    __DOTFILES_IGNORE_MISSING="${DOTFILES_IGNORE_MISSING:-}"
    DOTFILES_IGNORE_MISSING=1
    local dir=''
    for dir in "$DOTFILES_ROOT/opt"/*; do
        read -t 10 -n 1 -r -s -p "$(e_prompt "Process files in ${dir}? [y/N]")"
        if [[ "$REPLY" =~ ^[Yy]$ ]]; then
            DOTFILES_ROOT="$dir" process_all "$DOTFILES_RUNDIR"
        else
            echo "Skipping..."
        fi
    done

    run () { : ; }
}

run () { : ; }

post () {
    DOTFILES_ROOT="$__DOTFILES_ROOT"
    DOTFILES_IGNORE_MISSING="$__DOTFILES_IGNORE_MISSING"
    unset __DOTFILES_ROOT __DOTFILES_IGNORE_MISSING
}
