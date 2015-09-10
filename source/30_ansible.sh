#!/usr/bin/env bash

# Where local modules should go.
eval "$(env_unshift ANSIBLE_LIBRARY "${HOME}/.ansible/modules.d")"

# A tiny li'l wrapper function that helps set roles up the way I like.
ansible-galaxy () {
    command ansible-galaxy "$@"
    local -i exit_code=$?
    (( exit_code == 0 )) || return $exit_code

    case "$1" in
        init)
            local -i i
            local init_path=''
            local opt=''
            for (( i = 2 ; i <= $# ; i++ )); do
                opt="${!i}"
                if [[ "${opt}" == -h ]] || [[ "${opt}" == --help ]]; then
                    return $exit_code
                fi
                if [[ "${opt}" == -p ]] || [[ "${opt}" == --init-path ]]; then
                    ((i++))
                    init_path="${!i}"
                fi
            done

            init_path="${init_path:-"$PWD"}"
            local role_name="${*:$#:1}"
            local ansible_cfg="${init_path}/${role_name}/ansible.cfg"
            local inventory="${init_path}/${role_name}/hosts"

            [[ -e "$ansible_cfg" ]] || printf '%s' "\
[defaults]
# Make it easy to run sample playbook from repository root
roles_path = ..
inventory = hosts
" > "$ansible_cfg"

            [[ -e "$inventory" ]] || printf '%s' "\
[arch]

[local]
localhost

[arch:children]
local

[arch:vars]
ansible_python_interpreter = /usr/bin/python2

[local:vars]
ansible_connection = local
" > "$inventory"
            ;;
        *)
            # Anything besides 'init' is ignored.
            :
            ;;
    esac
}
