#!/bin/bash
# Make setting the timezone easier
#
# Copyright 2018, F123 Consulting, <information@f123.org>
# Copyright 2018, Storm Dragon, <storm_dragon@linux-a11y.org>
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

# Setup gettext
export TEXTDOMAIN=timezone.sh
export TEXTDOMAINDIR=/usr/share/locale
. gettext.sh

export DIALOGOPTS='--insecure --no-lines --visit-items'

# Get the list of timezones
mapfile -t regions < <(timedatectl --no-pager list-timezones | cut -d '/' -f1 | sort -u)

# Use the same text twice here and just hide the tag field.
region=$(dialog --backtitle "$(gettext "Select your Region")" \
    --no-tags \
    --menu "$(gettext "Use up and down arrow or page-up and page-down to navigate the list.")" 0 0 0 \
    $(for i in ${regions[@]} ; do echo "$i";echo "$(gettext "$i")";done) --stdout)

mapfile -t cities < <(timedatectl --no-pager list-timezones | grep "$region" | cut -d '/' -f2 | sort -u)

# Use the same text twice here and just hide the tag field.
city=$(dialog --backtitle "$(gettext "Select a city near you")" \
    --no-tags \
    --menu "$(gettext "Use up and down arrow or page-up and page-down to navigate the list.")" 0 0 10 \
    $(for i in ${cities[@]} ; do echo "$i";echo "$(gettext "$i")";done) --stdout)

# Set the timezone
sudo timedatectl set-timezone ${region}/${city} >& /dev/null
# Make sure we are syncing with the internet
sudo timedatectl set-ntp true >& /dev/null
exit 0
