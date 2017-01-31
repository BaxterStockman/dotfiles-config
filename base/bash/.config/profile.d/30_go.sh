#!/usr/bin/env bash

# Make local gems available
exists go || return

eval "$(env_unshift GOPATH ~/.go)"
eval "$(env_unshift PATH ~/.go/bin)"
