#!/bin/bash
# configure-sound
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
                                                                                
export TEXTDOMAIN=configure-sound
export TEXTDOMAINDIR=/usr/share/locale
. gettext.sh

# Load F123 includes
for i in /usr/lib/F123-includes/*.sh ; do
    source $i
done

# How was this script called?
CALLED=${0##*/}

soundAction="$(menulist "USB_Soundcard" "$(gettext "USB_Soundcard")" "3MM_Jack" "$(gettext "3MM_Jack")")"
[[ $? -ne 0 ]] && exit 0

if [[ "$soundAction" == "USB_Soundcard" ]]; then
    echo "blacklist snd_bcm2835" | sudo tee /etc/modprobe.d/onboard_sound.conf &> /dev/null
else
    [[ -f "/etc/modprobe.d/onboard_sound.conf" ]] && sudo rm -f "/etc/modprobe.d/onboard_sound.conf"
fi

[[ "$(yesno "$(gettext "You need to reboot for the changes to take affect. Would you like to reboot now?")")" == "Yes" ]] && sudo reboot

exit 0
