#!/bin/bash
# configure-speech
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

# include script functions
for i in /usr/lib/F123-includes/*.sh ; do
    source $i
done

declare -a speechOptions
# For additional speech options, just add them to the for list
for i in espeak-ng mbrola ; do
    command -v $i &> /dev/null && {
        speechOptions+=("$i");
        speechOptions+=("|");
    }
done

speechProvider="$(menulist ${speechOptions[@]})"
speechProvider="${speechProvider,,}"

case "$speechProvider" in
    "mbrola") speechProvider="espeak-ng-mbrola-generic";;
esac

# Set the  chosen speech provider option.
sudo sed -i.bak "s/^[[:space:]]*DefaultModule  [[:space:]]*\S*$/ DefaultModule   $speechProvider/" /etc/speech-dispatcher/speechd.conf

# Clear any keypresses in the buffer:
read -t .001 continue

# Load the new settings:
sudo pkill -1 speech-dispatch
spd-say "If you can hear this press any key to accept these changes. Otherwize the old settings will return after 10 seconds." &
read -n1 -t10 -p "If you can hear this press any key to accept these changes. Otherwize the old settings will return after 10 seconds." continue
# Error code 142 means a key was not pressed, so restore from backup.
if [[ $? -eq 142 ]]; then
    sudo mv /etc/speech-dispatcher/speechd.conf.bak /etc/speech-dispatcher/speechd.conf
    # Load the old settings:
    sudo pkill -1 speech-dispatch
    exit 1
fi

# Restart Fenrir with new speech provider changes
sudo systemctl restart fenrirscreenreader
# Attempt to restart orca to apply changes if it is running:
if pgrep orca &> /dev/null ; then
    for i in {0..11} ; do
        DISPLAY=:$i orca --replace &
        [[ $? -eq 0 ]] && break
    done
fi

# Remove the backup file.
[[ -f /etc/speech-dispatcher/speechd.conf.bak ]] && sudo rm -f /etc/speech-dispatcher/speechd.conf.bak &> /dev/null
exit 0
