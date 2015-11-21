#!/usr/bin/env bash

header="Running initialization files"

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
run () {
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    local srcfile="$1"
    e_header "Sourcing ${srcfile}"
    source "$srcfile"
}

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
parseopts () {
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    while (( $# )); do
        case "$1" in
            -V|--skip-vim-plugins)
                export DOTFILES_SKIP_VIM_PLUGINS=1
                shift
                ;;
        esac
    done
}

parseopts "$@"
