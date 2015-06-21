#!/usr/bin/env bash
# Bashrc SSH-tmux wrapper | Spencer Tipping
# Licensed under the terms of the MIT source code license

# Source this just after the PS1-check to enable auto-tmuxing of your SSH
# sessions. See https://github.com/spencertipping/bashrc-tmux for usage
# information.

# Don't source this file if tmux isn't runnable
type -a tmux &>/dev/null || return

# Don't start if we're root
[[ "${EUID}" -eq 0 ]] && return

# Use a separate socket if we're running in a low-color environment
if [[ "${TERM}" == linux ]]; then
    alias tmux='tmux -L locolor'
    return
fi

if [[ "$(tput colors)" -ge 256 ]]; then
    alias tmux='tmux -2'
fi

if [[ -z "${TMUX}" ]] && exists tmux &> /dev/null; then
  if [[ -n "${SSH_CONNECTION}" ]]; then
    prefix="ssh"
  else
    prefix="local"
  fi

  base_session="${prefix}-${USER}"

  # Start base session if not already started.
  if ! tmux has -t "${base_session}"; then
    tmux new-session -s "${base_session}" \; detach
  fi

  declare -A session_index_attached
  while read -r session_name session_attached; do
    [[ "${session_name}" == "${base_session}" ]] && continue
    session_index="${session_name##"${base_session}-"}"
    session_index_attached["${session_index}"]="${session_attached}"
  done < <(tmux ls -F '#{session_name} #{session_attached}')

  create_index=0
  while true; do
    if ! tmux has -t "${base_session}-${create_index}"; then
      break
    elif [[ "${session_index_attached["${create_index}"]}" -eq 0 ]]; then
      exec tmux attach -t "${base_session}-${create_index}"
    fi
    ((create_index++))
  done

  if [[ -n "${SSH_CONNECTION}" ]]; then
    exec tmux new-session -s "${base_session}-${create_index}" \
      -t "${base_session}"
  else
    exec tmux new-session -s "${base_session}-${create_index}"
  fi
fi
