#!/bin/bash

mudURL="$1"
mudName="${mudURL##*/}"
mudName="${mudName%.git}"
if [[ ! -d "$HOME/$mudName" ]]; then 
    git -C "$HOME" clone "$mudURL" | dialog --progressbox "Downloading and installing game files, please wait..." 0 0
else
    git -C "$HOME/$mudName" pull "$mudURL" | dialog --progressbox "Making sure everything is up to date, please wait..." 0 0
fi

cd "$HOME/$mudName"
mudLauncher="$(ls -1 *.tin)"
tt++ $mudLauncher
exit 0
