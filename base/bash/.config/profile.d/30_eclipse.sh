#!/usr/bin/env bash

# Just a simple PATH alteration and some other environment stuff
if exists eclipse; then
    eval "$(path_unshift /usr/share/eclipse)"
    export ECLIPSE_HOME=/usr/share/eclipse
fi
