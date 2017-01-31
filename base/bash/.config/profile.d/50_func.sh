#!/usr/bin/env bash

# cd and ls in one
cl() {
    cd "$@" && ls
}

# Temporary workspace
work() {
    stored="$(pwd -P)"
    tmpdir="$(mktemp -d)"

    cd "$tmpdir" || return $?
    "${SHELL:-$BASH}"
    cd "$stored" || :
    printf 1>&2 -- 'Leaving workspace in %s\n' "$tmpdir"
    rm --one-file-system --interactive=once -v -r "$tmpdir"
}

# calculator
calc() {
    echo "scale=3;$*" | bc -l
}

# Create a new directory and enter it
md() {
    mkdir -p "$@" && cd "$@"
}

# Set the terminal's title bar.
titlebar() {
    echo -n $'\e]0;'"$*"$'\a'
}

in_interactive_toplevel() {
    # Some sanity checks
    [[ "$-" == *i* ]] && (( BASH_SUBSHELL == 0 ))
}

if [[ -n $TMUX ]]; then
    declare() {
        builtin declare "$@" || return $?

        # Shortcircuit if we're not running interactively, are in a subshell,
        # or in a function.
        in_interactive_toplevel || return

        # Pre-parse declarations in order to ensure we're dealing only with
        # "scalar" variables.
        local -A stop_flags=()
        for stop_flag in f F p a A; do
            stop_flags["-$stop_flag"]=1
        done

        local var='' val=''
        for item in "$@"; do
            if (( "${stop_flags[$item]:-0}" == 1 )); then
                return
            elif [[ "$item" == -* ]]; then
                continue
            fi

            if [[ "$item" == *=* ]]; then
                var="${item%%=*}"
                val="${item#*=}"
            else
                var="$item"
                val="${!var}"
            fi

            command tmux setenv "$var" "$val"
        done

        # TODO handle -n -- i.e., reference

    }

    export() {
        builtin export "$@" || return $?

        # Shortcircuit if we're not running interactively, are in a subshell,
        # or in a function.
        in_interactive_toplevel || return

        # Don't set these variables in the tmux environment.
        # TERM - it is possible to run tmux sessions in two different terminal
        # types, and if (for instance) the two types support different numbers
        # of colors, we will get weird display issues.
        local -A noexport
        for env_var in TERM; do
            noexport["$env_var"]=1
        done

        # Pre-parse declarations in order to ensure we're dealing only with
        # "scalar" variables.
        local -A stop_flags=()
        for stop_flag in f p; do
            stop_flags["-$stop_flag"]=1
        done

        local var='' val=''
        for item in "$@"; do
            if (( "${stop_flags[$item]:-0}" == 1 )); then
                return
            elif [[ "$item" == -* ]]; then
                continue
            fi

            if [[ "$item" == *=* ]]; then
                var="${item%%=*}"
                val="${item#*=}"
            else
                var="$item"
                val="${!var}"
            fi

            (( ${noexport["$var"]:-0} == 1 )) && continue

            command tmux setenv "$var" "$val"
        done
    }

    unset () {
        builtin unset "$@" || return $?

        # Shortcircuit if we're not running interactively, are in a subshell,
        # or in a function.
        in_interactive_toplevel || return

        for item in "$@"; do
            [[ "$item" == -* ]] && continue

            command tmux setenv -ur "$item"
        done
    }
fi

clean_path () {
    local varname="${1:-PATH}"
    local -A elem_map
    local -a new_var_elems

    while read -r -d ':' elem; do
        [[ -z "${elem}" ]] && continue
        if [[ -z "${elem_map["${elem}"]}" ]]; then
            elem_map["${elem}"]="${elem}"
            new_var_elems+=("${elem}")
        fi
    done <<< "${!varname}"

    local IFS=:
    echo "${varname}=${new_var_elems[*]} ; export ${varname}"
}

clean_shell() {
    builtin unset -f export declare unset &>/dev/null
    builtin unset -v PROMPT_COMMAND &>/dev/null
    builtin trap - debug &>/dev/null
}
