#!/bin/sh
#
# ~/.xinitrc
#

export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-${HOME}/.config}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-${HOME}/.cache}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}"
mkdir -p "$XDG_CONFIG_HOME" "$XDG_CACHE_HOME" "$XDG_CONFIG_HOME"

DEFAULT_WM="${DEFAULT_WM:-i3-with-merged-config}"

if [ -d /etc/X11/xinit/xinitrc.d ]
then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

for xprofile in "${XDG_CONFIG_HOME}/xinitrc"/*; do
  [ -f "$xprofile" ] && . "$xprofile"
done
unset xprofile

if [ -f ~/.Xresources ]; then
    if [ -d "${XDG_CONFIG_HOME}/Xresources" ]; then
        xrdb -I"${XDG_CONFIG_HOME}/Xresources" -merge ~/.Xresources
    else
        xrdb -merge ~/.Xresources
    fi
fi

if command -v urxvtd >/dev/null 2>&1; then
    urxvtd -q -o -f
    # Set the value of 'i3-sensible-terminal' properly, so that it will spawn
    # an urxvt client rather than a new instance of the server or a clone of
    # the server.
    export TERMINAL=urxvtc
fi

if [ "$#" -gt 0 ]; then
    exec "$@"
else
    exec "${DEFAULT_WM}"
fi
