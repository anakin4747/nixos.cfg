
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
unsetopt beep
#
# VIM
bindkey -v
bindkey "^H" backward-delete-char
bindkey "^?" backward-delete-char

prompt off 2> /dev/null

autoload -Uz vcs_info
precmd() { vcs_info }
zstyle ':vcs_info:git:*' formats '%b '

setopt PROMPT_SUBST

ERR_CODE='%B%F{red}%(?..%? )%f%b'
GIT_FMT='%F{green}${vcs_info_msg_0_}%f'
PROMPT_ICON_FMT='%B%F{blue}$ %f%b'
PROMPT="$ERR_CODE$GIT_FMT%T $PROMPT_ICON_FMT"
