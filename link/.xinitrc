#!/bin/sh
#
# ~/.xinitrc
#

if [ -d /etc/X11/xinit/xinitrc.d ]
then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

[ -f ~/.xinitrc.local ] && . ~/.xinitrc.local
if [ -f ~/.Xresources ]; then
    if [ -d ~/.Xresources.d ]; then
        xrdb -I"${HOME}/.Xresources.d" -merge ~/.Xresources
    else
        xrdb -merge ~/.Xresources
    fi
fi

if command -v urxvtd >/dev/null 2>&1; then
    urxvtd -q -o -f
    # Set the value of 'i3-sensible-terminal' properly, so that it will spawn
    # an urxvt client rather than a new instance of the server, or a clone of
    # the server.
    export TERMINAL=urxvtc
fi

if [ -n "$1" ]; then
    echo ":: $(date) - Calling $1" >> ~/startx.log
    exec "$1"
else
    echo ":: $(date) - Calling i3" >> ~/startx.log
    exec i3
fi
