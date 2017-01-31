#!/usr/bin/env bash

# Make local gems available
exists ruby && exists gem || return

if exists chruby-exec; then
    for chruby_env in /usr/share/chruby/{chruby,auto}.sh; do
        # shellcheck disable=SC1090
        [[ -f "$chruby_env" ]] && source "$chruby_env"
    done
fi
