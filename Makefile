.PHONY: all base

base:
	(cd base; stow *)

$@: base
	cd $@
	stow *
