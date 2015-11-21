#!/usr/bin/env bash

header="Linking files into ${DOTFILES_DESTDIR}"

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
check () {
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    local srcfile="$1"
    local destfile="$2"

    if [[ -e "${destfile}" ]]; then
        if [[ "${srcfile}" -ef "${destfile}" ]]; then
            echo "link already exists"
            return "$DOTFILES_EX_TEMPFAIL"
        else
            echo "${destfile} exists but is not a link"
            return "$DOTFILES_EX_CANTCREAT"
        fi
    fi

    return 0
}

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
run () {
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    local srcfile="$1"
    local destfile="$2"
    local destdir="${destfile%/*}"

    if ! mkdir -p "$destdir" >/dev/null; then
        e_error "Can't link ${destfile} to ${srcfile} - failed to creat ${destdir}"
        return "$DOTFILES_EX_CANTCREAT"
    fi

    ln -sf "$srcfile" "$destfile"
    e_success "Linking ${srcfile} to ${destfile}"
    return "$DOTFILES_EX_OK"
}
