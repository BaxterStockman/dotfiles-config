#!/usr/bin/env bash

# cd and ls in one
function cl() {
    cd "$1" && ls
}

# calculator
function calc() {
    echo "scale=3;$*" | bc -l
}

# Create a new directory and enter it
function md() {
    mkdir -p "$@" && cd "$@"
}

# Set the terminal's title bar.
function titlebar() {
  echo -n $'\e]0;'"$*"$'\a'
}

if [[ -n $TMUX ]]; then
    function export () {
        local -a args=("$@")
        local -A noexport=(
            [TERM]=true
        )

        builtin export "$@"

        local var val trimmed_item
        for item in "${args[@]}"; do
            # Remove the longest substring between the beginning of a flag and a
            # space character.  This should remove all but the positional
            # parameters that the 'export' builtin was invoked with.
            trimmed_item="${item##-* }"

            var="${trimmed_item%%=*}"
            val="${trimmed_item#*=}"

            if "${noexport["$var"]:-false}"; then
                return
            fi

            # For the case 'export SOMEVAR'
            [[ "$val" == "$var" ]] && val="${!var}"

            command tmux setenv "$var" "$val"
        done
    }

    function unset () {
        local -a argv=("$@")
        builtin unset "$@"

        for item in "${argv[@]}"; do
            [[ "$item" == -* ]] && continue
            # Remove the longest substring between the beginning of a flag and
            # a space character.  This should remove all but the positional
            # parameters that the 'unset' builtin was invoked with.
            command tmux setenv -ur "$item"
        done
    }
fi

function clean_path () {
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
