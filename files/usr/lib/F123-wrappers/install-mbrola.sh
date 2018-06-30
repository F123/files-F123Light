#!/bin/bash
#
# This script automates setup of latest mbrola binary and Mbrola voices
# on Arch for x86 and armv7l/armv7h (Raspberry Pi) compatible hardware.
#
# Script is designed to be executed as the regular user, getting root privileges as needed
# It uses sudo to do this, which should allow prompting for the user's password only once.
#
# Copyright 2018, F123 Consulting, <information@f123.org>
# Copyright 2018, Valdis Vitolins, <valdis.vitolins@odo.lv>
# Copyright 2018, Kyle, <kyle@free2.ml>
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
###### Configuration #####
export TEXTDOMAIN=install-mbrola
export TEXTDOMAINDIR=/usr/share/locale
. gettext.sh

# Build a list of available voices based on the system language
# (just suffix, prefix 'mbrola-voices-' for package name will be added automatically):
# List of all vailable voices can be viewed at:
# https://aur.archlinux.org/packages/?O=0&K=mbrola-voices
case $LANG in
	af_ZA.UTF-8)
		voices="af1"
	;;
	ar_DZ.UTF-8)
		voices="ar1 ar2"
	;;
	de_DE.UTF-8)
		voices="de1 de2 de3 de4 de5 de6 de7 de8"
	;;
	en_US.UTF-8)
		voices="us1 us2 us3"
	;;
	es_ES.UTF-8)
		voices="es1 es2 es3 es4"
	;;
	fr_FR.UTF-8)
		voices="fr1 fr2 fr3 fr4 fr5 fr6 fr7"
	;;
	hi_IN)
		voices="in1 in2"
	;;
	hu_HU.UTF-8)
		voices="hu1"
	;;
	id_ID.UTF-8)
		voices="id1"
	;;
	pl_PL.UTF-8)
		voices="pl1"
	;;
	pt_BR.UTF-8)
		voices="br1 br2 br3 br4"
	;;
	tr_TR.UTF-8)
		voices="tr1 tr2"
	;;
	*)
		echo "$(gettext "No MBROLA voices are currently available for your language.")" && exit 0
	;;
esac

# Check status of mandatory operations and exit on failure
function check_error_exit {
  if [[ $? -ne 0 ]]; then
    echo "$(gettext "There was an error, when installing MBROLA.")"
    echo "$(gettext "Please, check entered password or network connectivity and try to run this script again!")"
    exit 1
  fi
}

# Check status of optional operations and continue
function check_error {
  if [[ $? -ne 0 ]]; then
    echo "$(gettext "==> WARNING: There was some error, which MAY be OK...")"
    return 1
  else
    return 0
  fi
}

function root_prompt {
  echo "$(gettext "Going to root user. Enter 'root'")"
}

################################
# Start with informative message
echo "$(eval_gettext "This script will install MBROLA software with $voices voices.")"; echo
echo "$(gettext "You may need to enter your password to install software.")"

# Get the password to allow root access
sudo -p "$(gettext 'Enter your password to continue ')" echo

# Update repositories
echo "$(gettext "Updating package databases...")"
sudo pacman -Sy >&/dev/null
check_error_exit

# Install MBROLA binary and voices from F123 archives
echo "$(gettext "Installing MBROLA binary...")"
sudo pacman --noconfirm -S --needed mbrola >& /dev/null
check_error
for v in $voices; do
  echo "$(eval_gettext "Installing ${v} MBROLA voice...")"; echo
sudo pacman --noconfirm -S --needed mbrola-${v} >& /dev/null
  check_error
done

# Set mbrola as default speech for the system.
# I did my best not to leave the user without speech. Fingers crossed...
command -v mbrola && {
    sudo sed -i.bak "s/^[[:space:]]*DefaultModule  [[:space:]]*\S*$/DefaultModule espeak-ng-mbrola-generic/" /etc/speech-dispatcher/speechd.conf
    # Restart Fenrir with new speech provider changes
    sudo systemctl restart fenrirscreenreader
    # Attempt to restart orca to apply changes if it is running:
    if pgrep orca &> /dev/null ; then
        for i in {0..11} ; do
            DISPLAY=:$i orca --replace &
            [[ $? -eq 0 ]] && break
        done
    fi
}

echo; echo "$(gettext "Setup is finished")"
echo "$(gettext "Please review output to check for errors.")"
