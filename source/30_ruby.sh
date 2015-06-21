#!/usr/bin/env bash

# Make local gems available
exists ruby && exists gem || return

GEM_HOME="$(ruby -rubygems -e 'print Gem.user_dir')"
export GEM_HOME
eval "$(path_unshift "${GEM_HOME}/bin")"
