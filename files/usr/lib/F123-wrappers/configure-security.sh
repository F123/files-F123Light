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

disable_password() {
    echo "%wheel ALL=(ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/f123
    msgbox "$(gettext "Passwords are no longer required to perform administrative tasks.")"
}

require_password() {
    echo "%wheel ALL=(ALL) ALL" | sudo tee /etc/sudoers.d/f123
    msgbox "$(gettext "Passwords are now required to perform administrative tasks.")"
}

disable_autologin() {
    sudo rm "/etc/systemd/system/getty@tty1.service.d/override.conf" 2> /dev/null
    msgbox "$(gettext "You will need to enter username and password at login for this computer.")"
}

enable_autologin() {
cat << DONE | sudo tee "/etc/systemd/system/getty@tty1.service.d/override.conf" &> /dev/null
[Service]
ExecStart=
ExecStart=-/usr/bin/agetty --autologin $SUDO_USER --noclear %I $TERM
Type=idle
DONE
    msgbox "$(gettext "You no longer need to enter username and password at login for this computer.")"
}

while : ; do
    action="$(menulist "enable_autologin" "$(gettext "Login to your computer without the need of entering username and password.")" "disable_autologin" "$(gettext "Require a username and password to login to your computer.")" "require_password" "$(gettext "request a password when making changes that require administrator access.")" "disable_password" "$(gettext "Make changes to your computer that require administrator access without requiring a password. (security risk)")" "exit" "$(eval_gettext "Close ${0##*/}")")"
    if [[ "$action" != "exit" && -n "$action" ]]; then
        eval "$action"
    else
        break
    fi
done

exit 0
