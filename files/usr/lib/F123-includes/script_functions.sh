#!/bin/bash
# Script Functions
# Useful stuff for getting keypresses, or doing repetitive taks
#
# Copyright 2018, F123 Consulting, <information@f123.org>
# Copyright 2018, Storm Dragon, <storm_dragon@linux-a11y.org>
#
# This is free software; you can redistribute it and/or modify it under the
# terms of the GNU General Public License as published by the Free
# Software Foundation; either version 3, or (at your option) any later
# version.
#
# This software is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this package; see the file COPYING.  If not, write to the Free
# Software Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
# 02110-1301, USA.
#
#--code--

# Get the coluns and lines of the "screen"
cols=$(tput cols)
lines=$(tput lines)
# Settings to improve accessibility of dialog.
export DIALOGOPTS='--insecure --no-lines --visit-items'

inputbox() {
    # Returns: text entered by the user
    # Args 1, Instructions for box.
    # args: 2 initial text (optional)
    dialog --backtitle "$(gettext "Enter text and press enter.")" \
        --inputbox "$1" $((lines - 5)) $cols "$2" --stdout
}

passwordbox() {
    # Returns: text entered by the user
    # Args 1, Instructions for box.
    # args: 2 initial text (optional)
    dialog --backtitle "$(gettext "Enter text and press enter.")" \
        --passwordbox "$1" $((lines - 5)) $cols "$2" --stdout
}

msgbox() {
# Returns: None
# Shows the provided message on the screen with an ok button.
dialog --msgbox "$*" $((lines - 5)) $cols
}

infobox() {
# Returns: None
# Shows the provided message on the screen with no buttons.
dialog --infobox "$*" $lines $cols
}

yesno() {
    # Returns: Yes or No
    # Args: Question to user.
    # Called  in if $(yesno) == "Yes"
    # Or variable=$(yesno)
    dialog --backtitle "$(gettext "Press 'Enter' for \"yes\" or 'Escape' for \"no\".")" --yesno "$*" $((lines - 5)) $cols --stdout
    if [[ $? -eq 0 ]]; then
        echo "Yes"
    else
        echo "No"
    fi
}

get_keypress() {
    # Returnes the pressed key.
    # There arre two ways to use this function.
    # first way, get_keypress variableName
    # Second way variableName="$(get_keypress)"
    # This variable name is long to absolutely minimize possibility of collision.
    local getKeypressFunctionReturnVariable=$1
    local returnedKeypress
    # Unset IFS to capture any key that is pressed.
    local ifs="$IFS"
    unset IFS
    read -sn1 returnedKeypress
    # Restore IFS
    IFS="$ifs"
    if [[ $getKeypressFunctionReturnVariable ]]; then
        eval $getKeypressFunctionReturnVariable="'$returnedKeypress'"
    else
        echo "$returnedKeypress"
    fi
}

checklist() {
    # Args: minimum group 2, multiples of 2, "tag" "choice"
    # returns: all selected tags
    # Descriptions with & as the first letter are checked by default (optional).
      local menuList
    if [[ $((${#@} / 2)) -gt $((lines - 5)) ]]; then
        local optionSize=$((lines - 5))
    else
        local optionSize=$((${#@} / 2))
    fi
    ifs="$IFS"
    IFS=$'\n'
    dialog --backtitle "$(gettext "Choose Multiselection: Please choose all that apply by arrowing to the option and pressing space. Checked items will have an asterisk (*).")" \
        --checklist "$(gettext "Please select the applicable options")" $((lines - 5)) $cols $optionSize $(
        while [[ $# -gt 0 ]]; do
            echo "$1"
            shift
            if [[ "${1::1}" == "&" ]]; then
            echo "${1:1}"
            echo "ON"
        else
            echo "$1"
            echo "OFF"
        fi
        shift
    done) --stdout
    IFS="$ifs"
}

menulist() {
    # Args: minimum group 2, multiples of 2, "tag" "choice"
    # returns: selected tag
      local menuList
    if [[ $((${#@} / 2)) -gt $((lines - 5)) ]]; then
        local optionSize=$((lines - 5))
    else
        local optionSize=$((${#@} / 2))
    fi
    ifs="$IFS"
    IFS=$'\n'
    dialog --backtitle "$(gettext "Use the up and down arrow keys to find the option you want, then press enter to select it.")" \
        --no-tags \
        --menu "$(gettext "Please select one")" 0 0 0 $@ --stdout
    IFS="$ifs"
}

radiolist() {
    # Args: minimum group 2, multiples of 2, "tag" "choice"
    # returns: single selected tag
    # The description with & as the first letter is checked by default (optional).
    if [[ $((${#@} / 2)) -gt $((lines - 5)) ]]; then
        local optionSize=$((lines - 5))
    else
        local optionSize=$((${#@} / 2))
    fi
    ifs="$IFS"
    IFS=$'\n'
        dialog --backtitle "$(gettext "Choose Single selection: Please choose one by arrowing to the option and pressing space. The checked item will have an asterisk (*).")" \
        --radiolist "$(gettext "Please select one")" $((lines - 5)) $cols $optionSize $(
        while [[ $# -gt 0 ]]; do
            echo "$1"
            shift
            if [[ "${1::1}" == "&" ]]; then
                echo "${1:1}"
                echo "ON"
            else
                echo "$1"
                echo "OFF"
            fi
            shift
        done) --stdout
    IFS="$ifs"
}

continue_prompt() {
    # Returnes: none
    # Optional args: Prompt text
    local promptText="${1:-When you understand and are ready, press any key to continue:}"
    local continue
    echo "$promptText "
    # Unset IFS to capture any key that is pressed.
    local ifs="$IFS"
    unset IFS
    read -sn1 continue
    # Restore IFS
    IFS="$ifs"
}
