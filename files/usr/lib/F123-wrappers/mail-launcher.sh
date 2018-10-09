#!/bin/bash
# mail-launcher.sh
# Description Launch the correct mail client as specified in preferences.
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
 
source ~/.preferences
case "${preferences[emailClient]}" in
    "mutt") echo "exec:::command mutt";;
    "thunderbird")
        echo 'exec:::python /usr/share/fenrirscreenreader/tools/fenrir-ignore-screen &> /dev/null
        exec:::echo -n "setting set screen#suspendingScreen=\$(</tmp/fenrirSuspend)" | socat - UNIX-CLIENT:/tmp/fenrirscreenreader-deamon.sock
        exec:::command $([[ -n $DEMOMODE ]] && echo '-v') startx /usr/lib/F123-wrappers/xlauncher thunderbird
        exec:::python /usr/share/fenrirscreenreader/tools/fenrir-unignore-screen &> /dev/null
        exec:::echo -n "setting set screen#suspendingScreen=\$(</tmp/ fenrirSuspend)" | socat - UNIX-CLIENT:/tmp/fenrirscreenreader-deamon.sock';;
    *) /usr/lib/F123-wrappers/configure-email.sh
esac

exit 0
