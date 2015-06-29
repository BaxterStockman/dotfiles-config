#!/usr/bin/env bash

header="Copying files into ${DOTFILES_DESTDIR}"

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
check () {
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Ensures that files in the destination aren't overwritten if either
#   - The destination file is exactly the same as the source file; or
#   - The destination file is newer than the source file.
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    local srcfile="$1"
    local destfile="$2"

    if [[ -e "${destfile}" && ! "$(md5cmp "${srcfile}" "${destfile}" 2> /dev/null)" ]]; then
        echo "same file"
        return 2
    elif [[ "$1" -ot "$2" ]]; then
        echo "destination file newer"
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
    local destfile="$2"
    local destdir="${destfile%/*}"

    if ! mkdir -p "$destdir" >/dev/null; then
        e_error "Can't copy ${srcfile} to ${destfile}"
        return 1
    fi

    if ! cp "$srcfile" "$destfile"; then
        e_error "Failed to copy ${srcfile} to ${destfile}"
        return 1
    else
        e_success "Copied ${srcfile} to ${destfile}"
        return 0
    fi
}

