#!/bin/sh
#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)

# Check whether a program exists
exists() {
    [[ -n "$1" ]] || echo "'exists' requires an argument" && return 1
    command -v "$1" >/dev/null 2>&1 || test -e "$1"
}

if [ -d /etc/X11/xinit/xinitrc.d ]
then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

[ -f ~/.xinitrc.local ] && . ~/.xinitrc.local
if [ -f ~/.Xresources ]
then
    if [ -d ~/.Xresources.d ]
    then
        echo 'WHAT' > ~/Xwhat.log
        xrdb -I"${HOME}/.Xresources.d" -merge ~/.Xresources
    else
        xrdb -merge ~/.Xresources
    fi
fi



if exists urxvtd
then
    urxvtd -q -o -f &
    # Set the value of 'i3-sensible-terminal' properly, so that it will spawn
    # an urxvt client rather than a new instance of the server, or a clone of
    # the server.
    export TERMINAL=urxvtc
fi

exec ${1:-i3}
