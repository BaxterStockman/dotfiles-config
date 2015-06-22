#!/usr/bin/env bash

header="Running deprecation checks"

check () {
    if [[ -z "${DOTFILES_OLD_VERSION:-}" ]]; then
        echo 'DOTFILES_OLD_VERSION is unset; cannot run deprecation checks'
        return 1
    fi

    return 0
}

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
run () {
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Attempts to copy a file, printing pretty output
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    local srcfile="$1"
    local srcfile_basename="${srcfile##*/}"
    local srcfile_version="${srcfile_basename%.*}"

    local comparison
    comparison="$(compare_versions "$DOTFILES_OLD_VERSION" \
        "$srcfile_version")"

    if (( comparison < 0 )); then
        source "$srcfile"
    fi
}

