#!/usr/bin/env/bash

# Set up perlbrew env and source perlbrew's bashrc
PERLBREW_ROOT="${HOME}/opt/perl5/perlbrew"

exists "${PERLBREW_ROOT}/bin/perlbrew" || exists /usr/bin/vendor_perl/perlbrew || return

export PERLBREW_ROOT

# shellcheck disable=SC1090
[[ -f "${PERLBREW_ROOT}/etc/bashrc" ]] && source "${PERLBREW_ROOT}/etc/bashrc"
