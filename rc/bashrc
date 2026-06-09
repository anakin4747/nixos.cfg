
# If not running interactively, don't do anything
[[ $- != *i* ]] && return

set -o vi

# On the fence about these
bind '"\t": menu-complete'
bind '"\e[Z": menu-complete-backward'

PROMPT_COMMAND=__prompt_command
__prompt_command() {
    local exit="$?"

    PS1=""

    local red="\e[01;31m"
    local blue="\e[01;34m"
    local green="\e[32m"
    local rst="\e[0m"

    if [ "${exit}" != 0 ]; then
        PS1+="${red}${exit}${rst} "
    fi

    # This breaks if not at project root
    if [ -d "${PWD}/.git" ]; then
         gitinfo=$(
             git describe --tags --exact-match 2> /dev/null ||
             git rev-parse --short HEAD 2> /dev/null
         )
         if [ -n "${gitinfo}" ]; then
             PS1+="${green}${gitinfo}${rst} "
         fi
    fi

    PS1+="\A ${green}\W ${blue}\$${rst} "
}
