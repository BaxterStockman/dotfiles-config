#
# ~/.bashrc
#

## If not running interactively, don't do anything
[[ $- != *i* ]] && return

## Environmental variables
export DOTFILES_ROOT="${DOTFILES_ROOT:-"${HOME}/.dotfiles"}"
export CONFIG_PATH=$DOTFILES_ROOT/source
PATH=$DOTFILES_ROOT/bin:$PATH

[[ -d $HOME/sbin ]] && PATH=$HOME/sbin:$PATH
[[ -d $HOME/bin ]] && PATH=$HOME/bin:$PATH
[[ -d $HOME/bin/scripts ]] && PATH=$HOME/bin/scripts:$PATH
export PATH

[[ -d $HOME/lib ]] && LD_LIBRARY_PATH=$HOME/lib:$LD_LIBRARY_PATH
[[ -d $HOME/lib64 ]] && LD_LIBRARY_PATH=$HOME/lib64:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH

# Source file if it exists
# First argument = directory
# Second argument = relative path of file
function src_file() {
    if [[ "$2" ]]; then
        source "$1/$2.sh"
    fi
}

# Source all files in a directory
function src_all() {
    local f
    for f in $1/*; do
        [[ -e $f && -r $f ]] && source "$f"
    done
}

# Run dotfiles script, then source.
function dotfiles() {
    "$DOTFILES_ROOT"/bin/dotfiles "$@" && src_all "$CONFIG_PATH"
}

# Check whether a program exists
function exists() {
    command -v $1 >/dev/null 2>&1 || test -e $1
}

# Check whether a program exists and if so alias it to the string passed as the second argument.
# Syntax: alias_if <alias name>=<program name>
function alias_if() {
    OIFS="$IFS"
    IFS='=' read -a args <<<"$1"
    exists ${args[1]} && alias ${args[0]}="${args[1]}"
    IFS="$OIFS"
}

src_all "$CONFIG_PATH"

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
