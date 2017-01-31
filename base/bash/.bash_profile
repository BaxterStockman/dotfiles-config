#
# ~/.bash_profile
#

for bash_profile in ~/.bashrc{,local}; do
    if [[ -f "$bash_profile" ]] && [[ -r "$bash_profile" ]]; then
        source "$bash_profile"
    fi
done

unset -v bash_profile
