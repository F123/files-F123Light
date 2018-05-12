#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

#Change directories without using cd
shopt -s autocd

#load Aliases and functions
[[ -f ".bash_aliases" ]] && . .bash_aliases
[[ -f ".bash_functions" ]] && . .bash_functions
#Invironment variables
export QT_ACCESSIBILITY=1
PS1='[\u@\h \W] \$ '
export DIALOGOPTS='--no-lines --visit-items'
if [[ -n "$DISPLAY" ]]; then
    export BROWSER=firefox
    export EDITOR=pluma
else
    export BROWSER=w3m
    export EDITOR=nano
fi
GPG_TTY=$(tty)
export GPG_TTYA
export PAGER=w3m
# Don't put commands prefixed with space, or duplicate commands in history
export HISTCONTROL=ignoreboth

# Run a firstboot script, only if this is the top level shell, only if ~/.firstboot exists and only if a firstboot script exists.
test $SHLVL -eq 1 && test -e ${HOME}/.firstboot && test -e $(which firstboot) && firstboot

# Load Pdmenu , but only if this is the first shell
test $SHLVL -eq 1 && pdmenu -bun
