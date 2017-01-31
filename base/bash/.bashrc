#
# ~/.bashrc
#

## If not running interactively, don't do anything
[[ $- != *i* ]] && return

## Environmental variables
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-${HOME}/.config}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-${HOME}/.cache}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}"
mkdir -p "$XDG_CONFIG_HOME" "$XDG_CACHE_HOME" "$XDG_CONFIG_HOME"

export BASH_PROFILE="${BASH_PROFILE:-${XDG_CONFIG_HOME}/profile.d}"

for bindir in "${HOME}/"{sbin,bin}; do
    [[ -d "$bindir" ]] && PATH="${bindir}${PATH:+:$PATH}"
done
unset -v bindir
export PATH

for libdir in "${HOME}/"{lib,lib64}; do
    [[ -d "$libdir" ]] && LD_LIBRARY_PATH="${libdir}${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
done
unset -v libdir
export LD_LIBRARY_PATH

# Source all files in a directory
source_all () {
    local path="$1"

    local f
    for f in "${path}/"*; do
        if [[ -e "$f" ]] && [[ -r "$f" ]]; then
            source "$f"
        fi
    done
}

# Check whether a program exists
exists () {
    command -v "${1:?command string required}" >/dev/null 2>&1 || [[ -e "$1" ]]
}

# Check whether a program exists and if so alias it to the string passed as the
# second argument.
# Usage: alias_if <alias name>=<program name>
alias_if () {
    OIFS="$IFS"
    IFS='=' read -a args <<<"$1"
    exists "${args[1]}" && alias "${args[0]}"="${args[1]}"
    IFS="$OIFS"
}

source_all "$BASH_PROFILE"
