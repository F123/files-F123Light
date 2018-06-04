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
# Build a list of available voices based on the system language
# (just suffix, prefix 'mbrola-voices-' for package name will be added automatically):
# List of all vailable voices can be viewed at:
# https://aur.archlinux.org/packages/?O=0&K=mbrola-voices
case $LANG in
	af_ZA.UTF-8)
		voices="af1"
	;;
	ar_dz.UTF-8)
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
		echo No MBROLA voices are currently available for your language. && exit 0
	;;
esac
##########################
# Colorize output
RED='\033[0;31m'
GRN='\033[0;32m'
YEL='\033[1;33m'
BLD='\033[1;30m'
NC='\033[0m' # No Color

function check_response { # response as parameter
  ifs=$IFS
  unset IFS
  while true; do
    printf "Continue to run script? ${BLD}Enter${NC} to continue, ${BLD}escape${NC} to stop. "
    read -rs -N1 key
    printf "\n"
    case $key in
      $'\n')
        break
      ;;
      $'\e')
        IFS=$ifs
        exit 0
      ;;
      *)
      ;;
    esac
  done
  IFS=$ifs
  unset ifs
}

# Check status of mandatory operations and exit on failure
function check_error_exit {
  if [[ $? -ne 0 ]]; then
    printf "${RED}There was an error, when installing package.\n${NC}"
    printf "Please, check entered password or network connectivity and try to run this script again!\n${NC}"
    exit 1
  fi
}

# Check status of optional operations and continue
function check_error {
  if [[ $? -ne 0 ]]; then
    printf "${YEL}==> WARNING: ${BLD}There was some error, which MAY be OK...\n${NC}"
    return 1
  else
    return 0
  fi
}

function root_prompt {
  printf "${GRN}Going to root user${NC}. Enter ${BLD}'root'${NC} "
}

################################
# Start with informative message
printf "${GRN}This script will install MBROLA software with $voices voices.\n${NC}"
printf "${GRN}You will need to enter ${BLD}your${GRN} password to install software.\n${NC}"

# Check for answer and exit, if necessary
check_response response

# Get the password to allow root access
sudo -p 'Enter your password to continue ' printf "\n"

# Update repositories
printf "Updating package databases...\n"
sudo pacman -Sy >&/dev/null
check_error_exit

# Install MBROLA binary package from unsupported user archive
printf "Installing MBROLA binary package...\n"
cd /tmp
git clone https://odo.lv/git/aur/mbrola >& /dev/null #Ignore git errors, just check status
check_error
cd mbrola
makepkg --noconfirm >& /dev/null
sudo pacman --noconfirm -U --needed mbrola-*.xz >& /dev/null
check_error_exit

# Install MBROLA voices from supported user archives
for i in $voices; do
  printf "Installing ${BLD}${i}${NC} MBROLA voice...\n"
  cd /tmp
  git clone https://aur.archlinux.org/mbrola-voices-${i}.git >& /dev/null
  if [[ $(check_error) == 1 ]];then continue; fi
  cd mbrola-voices-$i
  makepkg --noconfirm >& /dev/null
  if [[ $(check_error) == 1 ]];then continue; fi
  sudo pacman --noconfirm -U --needed mbrola-voices-${i}*-any.pkg.tar.xz >& /dev/null
  check_error
done

printf "\n${BLD}Setup is finished${NC}\nPlease review output to check for errors.\n"
