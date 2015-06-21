#!/usr/bin/env bash

# Set up cabal env
CABAL_ROOT="${HOME}/.cabal"

exists "${CABAL_ROOT}/bin/cabal" || exists /usr/bin/cabal || return

export CABAL_ROOT
eval "$(path_unshift "${CABAL_ROOT}/bin")"
export PATH
