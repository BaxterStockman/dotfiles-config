#
# ~/.bash_profile
#

#[[ $(tty) =~ /dev/tty[1-6] ]] && fbterm
if [[ -f ~/.bashrc ]]; then . ~/.bashrc; fi
if [[ -f ~/.bashrc.local ]]; then . ~/.bashrc.local; fi
