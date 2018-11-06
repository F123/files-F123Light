#!/bin/bash

mudURL="$1"
mudName="${mudURL##*/}"
mudName="${mudName%.git}"
if [[ ! -d "$HOME/$mudName" ]]; then 
    git clone -C "$HOME" "$mudURL" | dialog --progressbox "Downloading and installing game files, please wait..." 0 0
else
    git clone -C "$HOME/$mudName" "$mudURL" | dialog --progressbox "Making sure everything is up to date, please wait..." 0 0
fi

cd $mudName
mudLauncher="$(ls -1 *.tin)"
exit 0
