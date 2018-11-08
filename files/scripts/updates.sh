#!/bin/bash
#
# Copyright 2018, F123 Consulting, <information@f123.org>
# Copyright 2018, Kyle, <kyle@free2.ml>
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

update 1811072200 && {
    # Install Pianobar Pandora client on builds last updated before 7 November 2018
    sudo pacman -S pianobar-git --noconfirm --needed &> /dev/null;
}
