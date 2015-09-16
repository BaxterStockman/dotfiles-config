#
# ~/.bashrc
#

## If not running interactively, don't do anything
[[ $- != *i* ]] && return

## Environmental variables
export DOTFILES_ROOT="${DOTFILES_ROOT:-"${HOME}/.dotfiles"}"
PATH=$DOTFILES_ROOT/bin:$PATH

[[ -d $HOME/sbin ]] && PATH=$HOME/sbin:$PATH
[[ -d $HOME/bin ]] && PATH=$HOME/bin:$PATH
[[ -d $HOME/bin/scripts ]] && PATH=$HOME/bin/scripts:$PATH
export PATH

[[ -d $HOME/lib ]] && LD_LIBRARY_PATH=$HOME/lib:$LD_LIBRARY_PATH
[[ -d $HOME/lib64 ]] && LD_LIBRARY_PATH=$HOME/lib64:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH

# Source all files in a directory
source_al l() {
    local path="$1"

    local f
    for f in "$path"/*; do
        [[ -e $f && -r $f ]] && source "$f"
    done
}

# Check whether a program exists
exists () {
    command -v $1 >/dev/null 2>&1 || test -e $1
}

# Check whether a program exists and if so alias it to the string passed as the
# second argument.
# Usage: alias_if <alias name>=<program name>
alias_if () {
    OIFS="$IFS"
    IFS='=' read -a args <<<"$1"
    exists ${args[1]} && alias ${args[0]}="${args[1]}"
    IFS="$OIFS"
}

source_all "${DOTFILES_ROOT}/source"
