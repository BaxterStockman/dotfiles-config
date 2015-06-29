header='Processing optional configuration'

pre () {
    __DOTFILES_ROOT="${DOTFILES_ROOT-}"
    __DOTFILES_IGNORE_MISSING="${DOTFILES_IGNORE_MISSING:-}"
    DOTFILES_IGNORE_MISSING=true
    local dir
    for dir in "$DOTFILES_ROOT/opt"/*; do
        read -t 10 -n 1 -s -p "$(e_prompt "Process files in ${dir}? ")"
        if [[ "$REPLY" =~ ^[Yy]$ ]]; then
            DOTFILES_ROOT="$dir"
            process_all "$DOTFILES_RUNDIR"
        else
            echo "Skipping..."
        fi
    done

    run () { : ; }
}

run () { : ; }

post () {
    DOTFILES_ROOT="${__DOTFILES_OLD_ROOT-}"
    unset __DOTFILES_OLD_ROOT
}

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
process_all_opt () {
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Iterate through directories in .dotfiles/opt, prompting user whether or not
# to process them.
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    local srcdir_relpath="$1"

    if [[ -d "${DOTFILES_ROOT}/${srcdir_relpath}" ]]; then
        local do_process
        read -N 1 -t 15 -p "$(e_prompt "Process optional ${srcdir_relpath##*/} files? [y/N]") " do_process
        echo

        if [[ "$do_process" =~ [Yy] ]]; then
            do_stuff "$srcdir_relpath"
        fi
    fi

    return 0
}

post () {
    DOTFILES_ROOT="$__DOTFILES_ROOT"
    DOTFILES_IGNORE_MISSING="$__DOTFILES_IGNORE_MISSING"
    unset __DOTFILES_ROOT __DOTFILES_IGNORE_MISSING
}

