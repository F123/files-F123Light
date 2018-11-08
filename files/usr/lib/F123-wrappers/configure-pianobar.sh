#!/bin/bash
# configure-pianobar.sh
# Description: Easily configure pianobar.
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

write_configuration() {
cat << EOF > "${configPath}/config"
user = $1
password = $2
event_command = $configPath/eventcmd.sh
audio_quality = high

act_songban = !
EOF
}

create_eventcmd() {
echo '#!/bin/bash
# create variables
while read L; do
k="$(echo "$L" | cut -d "=" -f 1)"
v="$(echo "$L" | cut -d "=" -f 2)"
export "$k=$v"
done < <(grep -e "^\(title\|artist\|album\|stationName\|pRet\|pRetStr\|wRet\|wRetStr\|songDuration\|songPlayed\|rating\|coverArt\|stationCount\|station[0-9]*\)=" /dev/stdin) # do not overwrite $1
album=$(echo "$album" | sed "s/ (Explicit)//g")
case "$1" in
"songstart")
echo "$artist\\$title\\$album\\$stationName" > '"$configPath"'/nowplaying
;;
"songfinish")
rm '"$configPath/nowplaying"'
;;' > "$configPath/eventcmd.sh"
echo "\"songlove\")
$0 -M
;;" >> "$configPath/eventcmd.sh"
echo '*)
if [ "$pRet" -ne 1 ]; then
echo "$1 failed"
elif [ "$wRet" -ne 1 ]; then
echo "$a failed, network error."
fi
;;
esac
exit 0' >> "$configPath/eventcmd.sh"
chmod 700 "$configPath/eventcmd.sh"
}

configPath="${XDG_CONFIG_HOME:-$HOME/.config}/pianobar"

[[ "$(yesno "A configuration file already exists, would you like to replace it?")" == "Yes" ]] && rm -rf "$configPath"

if [[ ! -d "$configPath" ]]; then
    email="$(inputbox "Please enter your Pandor account name. (email address)")"
    [[ -z "email" ]] && exit 0
    password="$(passwordbox "Please enter your Pandora password.")"
    [[ -z "password" ]] && exit 0
    mkdir -p "$configPath" &> /dev/null
    mkfifo "$configPath/ctl" &> /dev/null
    write_configuration "$email" "$password"
create_eventcmd
    # Find out if we need a proxy
    country="$(curl -s ipinfo.io | grep '"country":' | cut -d '"' -f4)"
    if [[ "${country^^}" != "US" ]]; then
        proxy="$(curl -s "https://gimmeproxy.com/api/getProxy?country=US" | grep '"ip":' | cut -d '"' -f4)"
            echo "control_proxy = ${proxy}:80" >> "$configPath/config"
    fi
    msgbox "Pianobar has been configured."
fi

exit 0
