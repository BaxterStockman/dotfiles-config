#!/usr/bin/env bash

#header="$(init::header)"

pre () { parseopts "$@" ; }

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
parseopts () {
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    for opt in "$@"; do
        case "$opt" in
            -V|--skip-vim-plugins)
                export DOTFILES_SKIP_VIM_PLUGINS=1
                break
                ;;
        esac
    done
}
