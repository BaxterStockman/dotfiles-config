#!/bin/bash

if [[ "$(locale charmap)" =~ UTF-8 ]]; then
    export LC_ALL="${LC_ALL:-en_US.UTF-8}"
fi
