#!/bin/bash
# configure-email.sh
# Description: Select prefered email client and configure it.
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
 
# Load functions and reusable code:
source /usr/lib/F123-includes/script_functions.sh

# List of possible email clients.
clientList=(
    mutt
    thunderbird
)

client="$(menulist $(for i in ${clientList[@]} ; do echo "$i $i"; done))"

# Set the new selection as the client in preferences
sed -i "s/\[emailClient\]=.*/[emailClient]=\"$client\"/"  ~/.preferences

# Open or configure the selected client.
case "${client}" in
    "mutt") command mutt;;
    "thunderbird") 
        python /usr/share/fenrirscreenreader/tools/fenrir-ignore-screen &> /dev/null
        echo -n "setting set screen#suspendingScreen=\$(</tmp/fenrirSuspend)" | socat - UNIX-CLIENT:/tmp/fenrirscreenreader-deamon.sock
        command startx /usr/lib/F123-wrappers/xlauncher thunderbird
        python /usr/share/fenrirscreenreader/tools/fenrir-unignore-screen &> /dev/null
        echo -n "setting set screen#suspendingScreen=\$(</tmp/fenrirSuspend)" | socat - UNIX-CLIENT:/tmp/fenrirscreenreader-deamon.sock;;
esac

exit 0
