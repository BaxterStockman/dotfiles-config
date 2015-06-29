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
    local opt_name opt_value
    while (( $# )); do
        read opt_name opt_value _ <<<"$@"
            case "$opt_name" in
                -V|--skip-vim-plugins)
                    export DOTFILES_SKIP_VIM_PLUGINS=true
                    shift
                    ;;
            esac
    done
}

parseopts "$@"
