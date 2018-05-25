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
                                                                                
# Load F123 includes
for i in ../F123-includes/* ; do
    source $i
done

disable_password() {
    sudo echo "%wheel ALL=(ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/f123.conf
}

require_password() {
    sudo echo "%wheel ALL=(ALL) ALL" | sudo tee /etc/sudoers.d/f123.conf
}

disable_autologin() {
    sudo rm "/etc/systemd/system/getty@tty1.service.d/override.conf" 2> /dev/null
}

enable_autologin() {
cat << EOF > "/etc/systemd/system/getty@tty1.service.d/override.conf"
[Service]
ExecStart=
ExecStart=-/usr/bin/agetty --autologin $SUDO_USER --noclear %I $TERM
Type=idle
EOF
}

while : ; do
    action="$(menulist "Enable Autologin" "Login to your computer without the need of entering username and password" "Disable Autologin" "Require a username and password to login to your computer." "Require Password" "request a password when making changes that require administrator access." "Disable Password" "Make changes to your computer that require administrator access without requiring a password. (security risk)" "Exit" "Close ${0##*/}")"
    action="$(echo "${action,,}" | sed 's/ /_/g')"
    if [[ "$action" != "exit" && -n "$action" ]]; then
        eval "$action"
    else
        break
    fi
done

exit 0
