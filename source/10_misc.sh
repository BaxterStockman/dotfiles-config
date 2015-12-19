#!/usr/bin/env bash

sv_remove () {
    local char="$1"
    shift
    local varname="$1"
    shift


    # Convert $char-separated variable to an array
    local IFS=$char
    local elems=(${!varname})
    unset IFS

    # Remove any unwanted elements from the array
    for to_remove in "$@"; do
        elems=("${elems[@]//$to_remove/}")
    done

    # Remove unset elements from the array
    local -i index
    for index in "${!elems[@]}"; do
        [[ -n "${elems[index]}" ]] || unset elems[index]
    done

    # Output the new array separated by $char
    IFS=$char
    echo "${elems[*]}"
}

sv_push () {
    local IFS="$1"
    shift
    local varname="$1"
    shift

    local varval="${!varname}"
    echo "${varval}${varval:+:}$*"
}

sv_unshift () {
    local IFS="$1"
    shift
    local varname="$1"
    shift

    local varval="${!varname}"
    echo "$*${varval:+:}${varval}"
}

env_remove () {
    local varname="$1"
    shift

    echo "${varname}=$(sv_remove $':' "$varname" "$@") ; export $varname"
}

env_push () {
    local varname="$1"
    shift

    local _removed=''
    _removed="$(sv_remove $':' "$varname" "$@")"

    export _removed

    local pushed=''
    pushed="$(sv_push $':' _removed "$@")"

    echo "${varname}=${pushed} ; export $varname"
}

env_unshift () {
    local varname="$1"
    shift

    local _removed=''
    _removed="$(sv_remove $':' "$varname" "$@")"

    export _removed

    local unshifted=''
    unshifted="$(sv_unshift $':' _removed "$@")"

    echo "${varname}=${unshifted} ; export $varname"
}

path_remove () {
    env_remove PATH "$@"
}

path_push () {
    env_push PATH "$@"
}

path_unshift () {
    env_unshift PATH "$@"
}

# Check whether a program exists
exists () {
    local cmd="$1"
    command -v "$cmd" &>/dev/null || type -a "$cmd" &>/dev/null
}
