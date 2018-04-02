#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='\W% '

# Don't put commands prefixed with space, or duplicate commands in history
export HISTCONTROL=ignoreboth

# Source user functions
. ~/.bash_functions

# Run a firstboot script, only if this is the top level shell, only if ~/.firstboot exists and only if a firstboot script exists.
test $SHLVL -eq 1 && test -e ${HOME}/.firstboot && test -e $(which firstboot) && firstboot

# Load a Kies menu, but only if this is the first shell
test $SHLVL -eq 1 && kiesmenu
