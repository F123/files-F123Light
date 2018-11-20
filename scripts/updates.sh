#!/bin/bash
#
# Copyright 2018, F123 Consulting, <information@f123.org>
# Copyright 2018, Kyle, <kyle@free2.ml>
# Copyright 2018, Storm Dragon <storm_dragon@linux-a11y.org>
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

# This is a helper script for update-f123light to perform incremental updates based on a timestamp
# It will not be installed to a running system
#
# Incremental updates are only to be performed if their timestamp is later than
# /etc/timestamp-F123Light on the system being updated.
# Each update should be formatted as
#
# update yymmddhhmm && {
# 	do-something here;
# 	do-something-else here;
# }
# If an update requires a reboot, add
# reboot=true
# anywhere in the update to prompt the user to reboot afterward
#
# Any new updates should be placed at the end of this file for best readability
# It is recommended to skip a line between updates, also for readability
# To get the current date and time in the format, use the command
# \date '+%y%m%d%H%M'
# Remember to add a ; after each line of the update group.

update 1811072200 && {
    # Install Pianobar Pandora client on builds last updated before 7 November 2018
    sudo pacman -S pianobar-git --noconfirm --needed &> /dev/null;
}

update 1811142036 && {
    sudo pacman -S --noconfirm --needed python-magic-wormhole &> /dev/null;
}

update 1811150406 && {
    # There has been a change to the pacman repository URL.
    # Copy the new pacman.conf file to all systems built earlier than 11 November 2018;
    sudo cp /tmp/F123Light/files/etc/pacman.conf /etc;
}

update 1811161939 && {
    # Install the update-f123light package;
    sudo pacman -Sy --noconfirm --needed --overwrite /usr/bin/update-f123light update-f123light &> /dev/null;
}

update 1811191827 && {
    # Blacklist non-working bluetooth module;
    echo "blacklist  btsdio" | sudo tee -a /etc/modules-load.d/bluetooth &> /dev/null;
    # Disable bluetooth service;
    sudo systemctl -q disable bluetooth;
    # Enable new bluetooth service;
    sudo systemctl -q enable brcm43438.service;
    # Add RHVoice module to speech-dispatcher;
    grep -q 'rhvoice\.conf' /etc/speech-dispatcher/speechd.conf || sudo sed -i 's/"espeak-mbrola-generic\.conf"/"espeak-mbrola-generic.conf"\n AddModule "rhvoice"    "sd_rhvoice"  "rhvoice.conf"/' /etc/speech-dispatcher/speechd.conf;
    # Create placeholder file for RHVoice;
    echo '# Placeholder for the rhvoice module.' | sudo tee /etc/speech-dispatcher/modules/rhvoice.conf &> /dev/null;
}
