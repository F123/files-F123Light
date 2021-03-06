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
[[ -f ".preferences" ]] && . .preferences
#Invironment variables
export QT_ACCESSIBILITY=1
export QT_LINUX_ACCESSIBILITY_ALWAYS_ON=1
PS1='[\W] % '
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
export PAGER="w3m -o keymap_file=~/.w3m/pager"
# Don't put commands prefixed with space, or duplicate commands in history
export HISTCONTROL=ignoreboth

# Show reminders for the day if there are any.
grep "^$(date '+%-m/%-e')" ~/calendar &> /dev/null && calendar | w3m

# Run a first-boot script, only if this is the top level shell, only if ~/.firstboot exists and only if a first-boot script exists.
test $SHLVL -eq 1 && test -e ${HOME}/.firstboot && test -e $(command -v first-boot) && command first-boot

# Make sure user based systemd stuff is working.
# Stop pulseaudio from autospawning which breaks sound horribly.
[[ -L "$HOME/.config/systemd/user/pulseaudio.socket" ]] || systemctl -q --user mask pulseaudio.socket >& /dev/null 

# Load Pdmenu , but only if this is the first shell
test $SHLVL -eq 1 && (pdmenu -squn;dialog --infobox "Press F10 to return to the menu" 0 0;)

### Added by surfraw. To remove use surfraw-update-path -remove
    export PATH=$PATH:/usr/lib/surfraw
### End surfraw addition.
