#!/usr/bin/env bash

# Ubuntu-only stuff. Abort if not Ubuntu.
[[ "$(cat /etc/issue 2> /dev/null)" =~ Ubuntu ]] || return 1

# Package management
alias update="sudo sh -c 'apt-get -qq update && apt-get upgrade'"
alias install="sudo sh -c 'apt-get install'"
alias remove="sudo sh -c 'apt-get remove'"
alias search="apt-cache search"

# Make 'less' more.
[[ -x /usr/bin/lesspipe ]] && eval "$(SHELL=/bin/sh lesspipe)"
