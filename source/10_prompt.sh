#!/usr/bin/env bash

# Set colorful PS1 only on colorful terminals.
function configure_color_prompts() {
    ## Solarized colors
    local BASE03 BASE02 BASE01 BASE00
    local BASE3 BASE2 BASE1 BASE0
    local BLACK RED GREEN YELLOW
    local BLUE MAGENTA CYAN WHITE
    local VIOLET ORANGE

    local BOLD RESET

    # Colors for elements of prompt:
    # ROOT_C            root username color
    # USERNAME_C        username color
    # AT_C              @-symbol color
    # HOSTNAME_C        hostname color
    # CWD_C             current working directory color
    # PROMPT_C          prompt character color
    # ERROR_FACE_C      error-indicator color
    # ERROR_PROMPT_C    prompt character color on error
    local ROOT_C USERNAME_C AT_C HOSTNAME_C
    local CWD_C PROMPT_C ERROR_FACE_C ERROR_PROMPT_C

    if tput setaf 1 &> /dev/null; then
        tput sgr0

        BOLD=$(tput bold)
        RESET=$(tput sgr0)

        local COLOR_COUNT
        COLOR_COUNT=$(tput colors 2>/dev/null)
        if [[ $COLOR_COUNT -ge 16 ]]; then
            if [[ $COLOR_COUNT -ge 256 ]]; then
                BASE03=$(tput setaf 234)
                BASE02=$(tput setaf 235)
                BASE01=$(tput setaf 240)
                BASE00=$(tput setaf 241)
                BASE3=$(tput setaf 230)
                BASE2=$(tput setaf 254)
                BASE1=$(tput setaf 245)
                BASE0=$(tput setaf 244)
                RED=$(tput setaf 160)
                GREEN=$(tput setaf 64)
                YELLOW=$(tput setaf 136)
                BLUE=$(tput setaf 33)
                MAGENTA=$(tput setaf 125)
                CYAN=$(tput setaf 37)
                VIOLET=$(tput setaf 61)
                ORANGE=$(tput setaf 166)
            else
                BASE03=$(tput setaf 8)
                BASE02=$(tput setaf 0)
                BASE01=$(tput setaf 10)
                BASE00=$(tput setaf 11)
                BASE3=$(tput setaf 15)
                BASE2=$(tput setaf 7)
                BASE1=$(tput setaf 14)
                BASE0=$(tput setaf 12)
                RED=$(tput setaf 1)
                GREEN=$(tput setaf 2)
                YELLOW=$(tput setaf 3)
                BLUE=$(tput setaf 4)
                MAGENTA=$(tput setaf 5)
                CYAN=$(tput setaf 6)
                VIOLET=$(tput setaf 13)
                ORANGE=$(tput setaf 9)
            fi

            ROOT_C="${BOLD}${RED}"
            USERNAME_C="${BOLD}${ORANGE}"
            AT_C="$BASE0"
            HOSTNAME_C="$YELLOW"
            CWD_C="${RESET}${BLUE}"
            PROMPT_C="$BLUE"
            ERROR_FACE_C="$RED"
            ERROR_PROMPT_C="$VIOLET"
        else
            local WHITE
            WHITE=$(tput setaf 7)
            local BLACK
            BLACK=$(tput setaf 0)
            RED=$(tput setaf 1)
            GREEN=$(tput setaf 2)
            YELLOW=$(tput setaf 3)
            BLUE=$(tput setaf 4)
            MAGENTA=$(tput setaf 5)
            CYAN=$(tput setaf 6)

            USERNAME_C="$GREEN"
            AT_C="$WHITE"
            HOSTNAME_C="$YELLOW"
            CWD_C="${RESET}${BLUE}"
            PROMPT_C="$BLUE"
            ERROR_FACE_C="$RED"
            ERROR_PROMPT_C="$MAGENTA"
        fi
    else
        clear

        BLUE="\e[1;34m"
        CYAN="\e[1;36m"
        GREEN="\033[1;32m"
        MAGENTA="\033[1;31m"
        ORANGE="\033[1;33m"
        RED="\e[1;31m"
        VIOLET="\033[1;35m"
        YELLOW="\e[1;33m"

        BOLD=""
        RESET="\033[m"

        echo -en "$CYAN"
        echo -en "$BLUE"
        echo -en "$GREEN"
        echo -en "$MAGENTA"
        echo -en "$ORANGE"
        echo -en "$RED"
        echo -en "$VIOLET"
        echo -en "$YELLOW"

        USERNAME_C="$GREEN"
        AT_C="$WHITE"
        HOSTNAME_C="$YELLOW"
        CWD_C="${RESET}${BLUE}"
        PROMPT_C="$BLUE"
        ERROR_FACE_C="$RED"
        ERROR_PROMPT_C="$MAGENTA"
    fi

    local PS1_user
    if [[ ${EUID} == 0 ]]; then
        PS1_user="\[$ROOT_C\]\h"
    else
        PS1_user="\[$USERNAME_C\]\u\[$AT_C\]@\[$HOSTNAME_C\]\h"
    fi
    local PS1_suff="\[${CWD_C}\] \w \$([[ \$? != 0 ]] && echo \"\[$ERROR_FACE_C\]:( \[$ERROR_PROMPT_C\]\")\\$\[$RESET\] "


    ## Export the prompt
    export PS1="${PS1_user}${PS1_suff}"
}

function set_prompts () {
# dircolors --print-database uses its own built-in database instead of using
# /etc/DIR_COLORS. Try to use the external file first to take advantage of user
# additions. Use internal bash globbing instead of external grep binary.

    # sanitize TERM:
    local safe_term=${TERM//[^[:alnum:]]/?}

    local dir_colors_file=''
    if [[ -f ~/.dir_colors ]]; then
        dir_colors_file=~/.dir_colors
    elif [[ -f /etc/DIR_COLORS ]]; then
        dir_colors_file=/etc/DIR_COLORS
    fi

    if [[ -z ${dir_colors_file} ]]; then
        type -P dircolors >/dev/null || return 1
        exec 514< <(dircolors --print-database)
    else
        exec 514<"$dir_colors_file"
    fi

    local entry='' term=''
    while read -r -u 514 entry term _; do
        [[ "$entry" == TERM ]] || continue

        # `$term' can contain a glob pattern, so is intentionally unquoted
        if [[ "$TERM" == $term ]]; then
            [[ -n "$dir_colors_file" ]] && eval "$(dircolors -b "$dir_colors_file")"

            configure_color_prompts

            case "$OSTYPE" in
                darwin|freebsd)
                    ;;
                *)
                    alias ls="ls --color=auto"
                    alias diff='colordiff'
                    alias dir="dir --color=auto"
                    alias grep="grep --color=auto"
                    alias dmesg='dmesg --color'
                    ;;
            esac

            return 0
        fi
    done

    # show root@ when we do not have colors
    PS1="\u@\h \w \$([[ \$? != 0 ]] && echo \":( \")\$ "

    # Use this other PS1 string if you want \W for root and \w for all other users:
    # PS1="\u@\h $(if [[ ${EUID} == 0 ]]; then echo '\W'; else echo '\w'; fi) \$([[ \$? != 0 ]] && echo \":( \")\$ "
}

set_prompts

# Try to keep environment pollution down, EPA loves us.
unset set_prompts configure_color_prompts

PS2="> "
PS3="~ "
PS4="+ "
