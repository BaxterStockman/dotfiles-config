#!/usr/bin/env bash

# Uses copy.sh's run()
source "${DOTFILES_RUNDIR}/"*"_copy.sh"

header="Copying skeleton files into ${DOTFILES_DESTDIR}";

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
check () {
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# More restrictive than copy_test: if the destination file exists at all, don't
# overwrite it.
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    local destfile="$2"

    if [[ -e "$destfile" ]]; then
        echo "destination file already exists"
        return 1
    fi
}
