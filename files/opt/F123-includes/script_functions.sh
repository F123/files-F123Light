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
