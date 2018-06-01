#!/bin/bash
# change-passwords
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

# Load F123 includes
for i in /usr/lib/F123-includes/* ; do
    source $i
done

set_password_with_text() {
local passOne="one"
local passTwo="two"
while [[ "$passOne" != "$passTwo" ]]; do
echo
read -ep "Enter password for $1: " passOne
read -ep "Enter password for $1 again: " passTwo
if [[ "$passOne" != "$passTwo" ]]; then
echo "Passwords do not match"
fi
done
echo "$1:$passOne" | chpasswd
}

# Provide possibility for setting passwords using plain text and readline navigation.
showPasswords="$(yesnow "Do you want speech feedback when setting passwords? This is a security risk as anyone looking at your screen can read your password, or if someone is listening, they will be able to hear what you are typing.")"

# Set prompt for select menu
PS3="Select account: "
select i in \
$(awk -F':' '{ if ( $3 >= 1000 && $3 <= 60000 && $7 != "/sbin/nologin" && $7 != "/bin/false" ) print $1; }' /etc/passwd) Cancel
do
if [[ "$i" == "Cancel" ]]; then
exit 0
fi
# If i is set to anything, we have a valid response and just need to exit the loop to continue.
if [[ -n "$i" ]]; then
break
fi
done
# Find out if we need sudo access to change the password
unset sudo
if [[ "$USER" != "$i" ]]; then
sudo="sudo"
fi
# If we don't have to provide plain text, just let the system do it's thing.
if [[ "$showPasswords" != "Yes" ]]; then
echo "passwd $i"
else
set_password_with_text $i
fi
exit 0
