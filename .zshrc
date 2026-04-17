
# # The following lines were added by compinstall
#
# zstyle ':completion:*' expand prefix
# zstyle ':completion:*' file-sort access
# zstyle ':completion:*' ignore-parents parent pwd directory
# zstyle ':completion:*' matcher-list '' 'm:{[:lower:]}={[:upper:]}' 'r:|[._-]=** r:|=**'
# zstyle ':completion:*' menu select=1
# zstyle ':completion:*' original true
# zstyle ':completion:*' preserve-prefix '//[^/]##/'
# zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
# zstyle ':completion:*' squeeze-slashes true
# zstyle ':completion:*' verbose true
# zstyle :compinstall filename '/home/kin/.zshrc'
#
# # Exclude ../ from directory completion
# zstyle ':completion:*' special-dirs .. parent
#
#
# autoload -Uz compinit
# compinit -i
# _comp_options+=(globdots)
#
#
# # History settings
# HISTFILE=~/.histfile
# HISTSIZE=1000000
# SAVEHIST=10000000
#
# setopt autocd # cd without cd
# setopt extendedglob
# setopt nomatch
# setopt notify
#
# # No alarm bell
# unsetopt beep
#
# # VIM
# bindkey -v
# bindkey "^H" backward-delete-char
# bindkey "^?" backward-delete-char
# # Vim directions in menus
# # bindkey -M menuselect 'h' vi-backward-char
# # bindkey -M menuselect 'j' vi-down-line-or-history
# # bindkey -M menuselect 'k' vi-up-line-or-history
# # bindkey -M menuselect 'l' vi-forward-char
#
#
# # Syntax Highlighting
# source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
#
# source ~/.aliases.sh
# source ~/.funcs.sh

# Zsh functions
#
# This is the printing of the exit code
# %B%F{red}%(?..%? )%f%b
#
# This is the user
# %B%F{blue}%n%f%b
#
# The @
# @
#
# Hostname
# %m
#
# PWD or ..
# %B%40<..<%~%<<
#
# ADD IF > 40 chars have a new line only if in that verbosity level
#
# %b%#
#
#   With git stuff
# %B%F{red}%(?..%? )%f%b%B%F{blue}%n%f%b@%m %B%40<..<%~%<< %b%F{magenta}(%fgit%F{magenta})%F{yellow}-%F{magenta}[%F{green}main%F{magenta}]%f %#


prompt off 2> /dev/null

autoload -Uz vcs_info
precmd() { vcs_info }
zstyle ':vcs_info:git:*' formats '%b '

setopt PROMPT_SUBST

ERR_CODE='%B%F{red}%(?..%? )%f%b'
GIT_FMT='%F{green}${vcs_info_msg_0_}%f'
PROMPT_ICON_FMT='%B%F{blue}$ %f%b'
PROMPT="$ERR_CODE$GIT_FMT%T $PROMPT_ICON_FMT"


# QUEIT_PROMPT="$ERR_CODE$GIT_FMT%T $PROMPT_ICON_FMT"
# # VERBOSE_PROMPT="$ERR_CODE %B%1~%b $GIT_FMT$PROMPT_ICON_FMT"
# # VERY_VERBOSE_PROMPT="$ERR_CODE %B%40<..<%~%<<%b $GIT_FMT$PROMPT_ICON_FMT"
#
#
# alias vp='toggle_verbose_prompt'
# VERBOSE=0
#
# toggle_verbose_prompt () {
#     if [ "$VERBOSE" = 0 ]; then
#         PROMPT=$VERBOSE_PROMPT
#         VERBOSE=1
#     elif [ "$VERBOSE" = 1 ]; then
#         PROMPT=$VERY_VERBOSE_PROMPT
#         VERBOSE=2
#     else
#         PROMPT=$QUEIT_PROMPT
#         VERBOSE=0
#     fi
# }
#
# # # sed -E 's/(^\w*$)/\o033[32m\1\o033[0m/g' ~/docs/GOALS
# #
# # export TERM="st-256color"
# #
# # export EDITOR="v"
# # export GIT_EDITOR="$EDITOR"
# #
# #
# # ############################################################
# # # Needed for Neovim as a terminal multiplexer              #
# # ############################################################
# # neovim_autocd() {
# #     [ $NVIM ] && nvim --server $NVIM --remote-send "<C-\\><C-N>:silent cd $PWD<CR>i" &> /dev/null
# # }
# # chpwd_functions+=( neovim_autocd )
# # ############################################################
# #
# # ulimit -c unlimited
# #
# # export PYENV_ROOT="$HOME/.pyenv"
# # eval "$(pyenv init - zsh)"
