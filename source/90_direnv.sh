#!/usr/bin/env bash

# Must come pretty late in the sourcing process, because it hooks into
# PROMPT_COMMAND
exists direnv && eval "$(direnv hook bash)"
