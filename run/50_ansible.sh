# XXX testing.
return
#!/usr/bin/env bash

header="Running ansible-playbook in local mode"

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
check () {
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    local playbook_path="$1"

    local python2_bin=python
    if [[ "$DOTFILES_OSTYPE" == arch ]]; then
        python2_bin=python2
    fi

    for bin in "$python2_bin" ansible-playbook; do
        if ! type -P "$bin" &>/dev/null; then
            echo "Can't run ${bin}; system configuration will be incomplete"
            return
        fi
    done

    if ! "$python2_bin" -c 'import ansible'; then
        echo "ansible-playbook is installed, but there's a problem with the" \
            " ansible python package.  System configuration will be incomplete"
    fi

    if ! [[ -f "$playbook_path" ]] \
      || ! [[ "$playbook_path" =~ playbook.yml$ ]]; then
        echo "$playbook_path is not a valid path to a playbook"
    fi
}

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
run () {
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    local playbook_path="$1"
    local python2_path

    if [[ "$DOTFILES_OSTYPE" == arch ]]; then
        python2_path=/usr/bin/python2
    fi

    ansible-playbook -c local -i localhost, \
        ${python2_path:+-e ansible_python_interpreter="$python2_path"} \
        -e git_vendor_path="${DOTFILES_ROOT}/vendor" \
        "$playbook_path"

    exit
}
