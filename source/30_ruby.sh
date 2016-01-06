#!/usr/bin/env bash

# Make local gems available
exists ruby && exists gem || return

GEM_HOME="$(ruby -rubygems -e 'print Gem.user_dir')"
export GEM_HOME
eval "$(path_unshift "${GEM_HOME}/bin")"

if exists chruby-exec; then
    for chruby_env in /usr/share/chruby/{chruby,auto}.sh; do
        # shellcheck disable=SC1090
        [[ -f "$chruby_env" ]] && source "$chruby_env"
    done
fi
