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

get_input()
{
    # Get user input args are return variable, question, options
    # Prefix an anser option with - to make it the default
    local __get_input_input=$1
    shift
    local __get_input_question="$1"
    shift
    local __get_input_answer=""
    local __get_input_i=""
    local __get_input_continue=false
    for __get_input_i in $@; do
        if [[ "${__get_input_i:0:1}" == "-" ]]; then
            local __get_input_default="${__get_input_i:1}"
        fi
    done
    while [[ "$__get_input_continue" == "false" ]]; do
        echo -n "$__get_input_question (${@/#-/}) "
        if [[ -n "$__get_input_default" ]]; then
            read -e -i "$__get_input_default" __get_input_answer
        else
            read -e __get_input_answer
        fi
        for __get_input_i in $@; do
            if [[ "$__get_input_answer" == "${__get_input_i/#-/}" ]]; then
                __get_input_continue=true
                break
            fi
        done
    done
    eval $__get_input_input="'$__get_input_answer'"
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
ifs="$IFS"
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
