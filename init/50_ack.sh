#!/usr/bin/env bash

e_header "Building and installing ack"

ack_submodule_dir="${DOTFILES_ROOT}/vendor/ack2"
ack_standalone_path="${ack_submodule_dir}/ack-standalone"
ack_bin_path="${DOTFILES_ROOT}/bin/ack"

if [[ -e "$ack_bin_path" ]] && [[ -e "$ack_standalone_path" ]] \
	&& [[ "$ack_bin_path" -ef "$ack_standalone_path" ]]; then
	e_arrow "ack is already built"
	return 0
fi


if [[ ! -d "$ack_submodule_dir" ]]; then
	e_error "ack submodule does not exist"
	return 1
fi

pushd "$ack_submodule_dir" >/dev/null

make clean 2>/dev/null
perl Makefile.PL
if ! make ack-standalone; then
    e_error "Failed to build ack-standalone"
    unlink "$ack_bin_path" 2>/dev/null
    popd >/dev/null
    return 1
fi

popd >/dev/null

ln -sfn "${ack_submodule_dir}/ack-standalone" "$ack_bin_path"
