#!/bin/bash
# configure-security
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
                                                                                
export TEXTDOMAIN=configure-security
export TEXTDOMAINDIR=/usr/share/locale
. gettext.sh

# Load F123 includes
for i in /usr/lib/F123-includes/* ; do
    source $i
done

source /dev/stdin << EOF
function $(gettext "Disable_Password")() {
    echo "%wheel ALL=(ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/f123
    msgbox "$(gettext "Passwords are no longer required to perform administrative tasks.")"
}

function $(gettext "Require_Password")() {
    echo "%wheel ALL=(ALL) ALL" | sudo tee /etc/sudoers.d/f123
    msgbox "$(gettext "Passwords are now required to perform administrative tasks.")"
}

function $(gettext "Disable_Autologin")() {
    sudo rm "/etc/systemd/system/getty@tty1.service.d/override.conf" 2> /dev/null
    msgbox "$(gettext "You will need to enter username and password at login for this computer.")"
}

function $(gettext "Enable_Autologin")() {
cat << DONE | sudo tee "/etc/systemd/system/getty@tty1.service.d/override.conf" &> /dev/null
[Service]
ExecStart=
ExecStart=-/usr/bin/agetty --autologin $SUDO_USER --noclear %I $TERM
Type=idle
DONE
    msgbox "$(gettext "You no longer need to enter username and password at login for this computer.")"
}
EOF

while : ; do
    action="$(menulist "$(gettext "Enable_Autologin")" "$(gettext "Login to your computer without the need of entering username and password")" "$(gettext "Disable_Autologin")" "$(gettext "Require a username and password to login to your computer.")" "$(gettext "Require_Password")" "$(gettext "request a password when making changes that require administrator access.")" "$(gettext "Disable_Password")" "$(gettext "Make changes to your computer that require administrator access without requiring a password. (security risk)")" "$(gettext "Exit")" "Close ${0##*/}")"
    action="$(echo "${action,,}" | sed 's/ /_/g')"
    if [[ "$action" != "$(gettext "exit")" && -n "$action" ]]; then
        eval "$action"
    else
        break
    fi
done

exit 0
