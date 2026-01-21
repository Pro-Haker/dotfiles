#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias ll='ls -lah'
alias grep='grep --color=auto'
alias cls='clear'

export LC_COLLATE=C
export PROMPT_DIRTRIM=3

PS1='\w \\$ '
