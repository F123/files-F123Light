#!/bin/bash
# F123 menu
#
# Copyright 2018, F123 Consulting, <information@f123.org>
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
#--code--

# Remember to make this script executable so pdmenu can access it.
export TEXTDOMAIN=pdmenurc
export TEXTDOMAINDIR=/usr/share/locale
. gettext.sh

cat << EOF
title:$(gettext "Welcome to F123 Light")

# Define the main menu.
menu:main:$(gettext "F123 Light Main Menu"):$(gettext "Use the up and down arrow keys to select your choice and press the 'Enter' key to activate it.")
	show:$(gettext "_Games Menu")..::games
	show:$(gettext "_Internet menu")..::internet
	show:$(gettext "_Media menu")..::media
	show:$(gettext "_Office menu")..::office
	show:$(gettext "_System Configuration Menu")..::configuration
	show:$(gettext "_Tools Menu")..::tools
	show:$(gettext "_Help Menu")..::help
	nop
	show:$(gettext "_Power Options")..::power
	nop
	exit:$(gettext "E_xit Menu")


# Submenu for games.
menu:games:$(gettext "Games"):$(gettext "Command line games")
	exec:$(gettext "_Adventure")::clear;adventure
	exec:$(gettext "_Arithmetic")::clear;arithmetic
	exec:$(gettext "_Air Traffic Controler (Not screen reader friendly)")::clear;atc
	exec:$(gettext "_Backgammon (Not screen reader friendly)")::clear;backgammon
	exec:$(gettext "_Battlestar")::clear;battlestar
	exec:$(gettext "_Boggle (Not screen reader friendly)")::clear;boggle
	exec:$(gettext "_Canfield (Not screen reader friendly)")::clear;canfield
	exec:$(gettext "_Cribbage (Not screen reader friendly)")::clear;cribbage
	exec:$(gettext "_Go Fish"):pause:clear;go-fish
	exec:$(gettext "_Gomoku")::clear;gomoku
	exec:$(gettext "_Hangman")::clear;hangman
	exec:$(gettext "_Hunt (Not screen reader friendly)")::clear;hunt
	exec:$(gettext "_Mille Bornes")::clear;mille
	exec:$(gettext "_Number")::clear;number
	exec:$(gettext "_Phantasia")::clear;phantasia
	exec:$(gettext "_Phase of the Moon"):pause:clear;pom
	exec:$(gettext "_Primes")::clear;primes
	exec:$(gettext "_Robots (Not screen reader friendly)")::clear;robots
	exec:$(gettext "_Sail")::clear;sail
	exec:$(gettext "_Snake (Not screen reader friendly)")::clear;snake
	exec:$(gettext "_Tetris (Not screen reader friendly)")::clear;tetris-bsd
	exec:$(gettext "_Trek")::clear;trek
	group:$(gettext "_Tux Math")
        exec:::clear
        exec:::python /usr/share/fenrirscreenreader/tools/fenrir-ignore-screen
        exec:::startx /usr/lib/F123-wrappers/tuxmath --tts
        exec:::python /usr/share/fenrirscreenreader/tools/fenrir-unignore-screen
    endgroup
	group:$(gettext "_Tux Type")
        exec:::clear
        exec:::python /usr/share/fenrirscreenreader/tools/fenrir-ignore-screen
        exec:::startx /usr/lib/F123-wrappers/tuxtype --tts
        exec:::python /usr/share/fenrirscreenreader/tools/fenrir-unignore-screen
    endgroup
	exec:$(gettext "_Worm (Not screen reader friendly)")::clear;worm
	exec:$(gettext "_Wumpus")::clear;wump

	nop
	exit:$(gettext "Main menu")..


# submenu for internet applications.
menu:internet:$(gettext "Internet"):$(gettext "Internet programs")
	group:$(gettext "Email (Thunderbird)")
        exec:::clear
        exec:::python /usr/share/fenrirscreenreader/tools/fenrir-ignore-screen
        exec:::startx /usr/lib/F123-wrappers/xlauncher thunderbird
        exec:::python /usr/share/fenrirscreenreader/tools/fenrir-unignore-screen
    endgroup
	nop:$(gettext "Web Browsers")
	exec:$(gettext "_Basic Web Browser (W3M)")::clear;w3m
	group:$(gettext "Full _Web browser (Firefox)")
        exec:::clear
        exec:::python /usr/share/fenrirscreenreader/tools/fenrir-ignore-screen
        exec:::startx /usr/lib/F123-wrappers/xlauncher firefox
        exec:::python /usr/share/fenrirscreenreader/tools/fenrir-unignore-screen
    endgroup
	nop:$(gettext "Communication")
	group:$(gettext "Instant Messenger (_Pidgin)")
        exec:::clear
        exec:::python /usr/share/fenrirscreenreader/tools/fenrir-ignore-screen
        exec:::startx /usr/lib/F123-wrappers/xlauncher pidgin
        exec:::python /usr/share/fenrirscreenreader/tools/fenrir-unignore-screen
    endgroup
	group:$(gettext "Voice Chat (_Mumble)")
        exec:::clear
        exec:::python /usr/share/fenrirscreenreader/tools/fenrir-ignore-screen
        exec:::startx /usr/lib/F123-wrappers/xlauncher mumble
        exec:::python /usr/share/fenrirscreenreader/tools/fenrir-unignore-screen
    endgroup
	nop
	exit:$(gettext "_Main menu")..

menu:media:$(gettext "Media"):$(gettext "Multi-media applications")
	exec:$(gettext "_CD Audio Ripper (ripit)")::ripit
	exec:$(gettext "_Music Player (cmus)")::cmus
	exec:$(gettext "_Stringed Instrument Tuner (bashtuner)")::bashtuner
	exec:$(gettext "_Youtube (audio only)")::youtube-viewer -novideo
	group:$(gettext "Youtube (full _video)")
        exec:::clear
        exec:::python /usr/share/fenrirscreenreader/tools/fenrir-ignore-screen
        exec:::startx /usr/lib/F123-wrappers/xlauncher lxterminal -e youtube-viewer
        exec:::python /usr/share/fenrirscreenreader/tools/fenrir-unignore-screen
    endgroup
	nop:$(gettext "Book Readers")
	group:$(gettext "Read Books in _Epub Format")
		exec::makemenu: \
		echo "menu:epub:$(gettext "Epub"):$(gettext "Select book to read")"; \
		for i in \$(find \$HOME -type f -iname "*.epub") ; do \
			j="\$(basename "\$i" .epub)"; \
			echo "exec:_\$j::epub2txt -p 80 '\$i' | w3m"; \
		done; \
		echo "exit:$(gettext "Back to Media Menu").."
		show:::epub
		remove:::epub
	endgroup
	nop
	exit:$(gettext "_Main menu")..


menu:office:$(gettext "Office"):$(gettext "Word processing, calendar, etc")
	exec:$(gettext "_Month Calendar"):pause:clear;ncal
	exec:$(gettext "_Year Calendar"):pause:clear;ncal -y
	exec:$(gettext "Text _Editor")::clear;${EDITOR:-nano}
	nop:$(gettext "Office Suite")
	group:$(gettext "Spreadsheet")
        exec:::clear
        exec:::python /usr/share/fenrirscreenreader/tools/fenrir-ignore-screen
        exec:::startx /usr/lib/F123-wrappers/xlauncher localc
        exec:::python /usr/share/fenrirscreenreader/tools/fenrir-unignore-screen
    endgroup
	group:$(gettext "Word Processor")
        exec:::clear
        exec:::python /usr/share/fenrirscreenreader/tools/fenrir-ignore-screen
        exec:::startx /usr/lib/F123-wrappers/xlauncher lowriter
        exec:::python /usr/share/fenrirscreenreader/tools/fenrir-unignore-screen
    endgroup
	group:$(gettext "Libre Office (All Applications)")
        exec:::clear
        exec:::python /usr/share/fenrirscreenreader/tools/fenrir-ignore-screen
        exec:::startx /usr/lib/F123-wrappers/xlauncher soffice
        exec:::python /usr/share/fenrirscreenreader/tools/fenrir-unignore-screen
    endgroup
	nop
	exit:$(gettext "_Main menu")..


# submenu for configuring the computer.
menu:configuration:$(gettext "Configuration"):$(gettext "System Configuration")
	exec:$(gettext "_Change Passwords")::clear;/usr/lib/F123-wrappers/configure-passwords
	exec:$(gettext "_Email Configuration")::clear;fleacollar
	exec:$(gettext "_Security Configuration")::clear;/usr/lib/F123-wrappers/configure-security.sh
	exec:$(gettext "_Change System Speech")::clear;/usr/lib/F123-wrappers/configure-speech.sh
	exec:$(gettext "_Change Soundcard")::clear;/usr/lib/F123-wrappers/configure-sound.sh
	exec:$(gettext "_Wireless Internet Connection")::clear;sudo configure-wifi
	nop
	exit:$(gettext "_Main menu")..

menu:tools:$(gettext "Tools"):$(gettext "System Tools")
	exec:$(gettext "File _Browser")::clear;mc -K /etc/mc/mc.keymap
	group:$(gettext "Bluetooth manager")
        exec:::clear
        exec:::python /usr/share/fenrirscreenreader/tools/fenrir-ignore-screen
        exec:::startx /usr/lib/F123-wrappers/xlauncher blueman-assistant
        exec:::python /usr/share/fenrirscreenreader/tools/fenrir-unignore-screen
    endgroup
exec:$(gettext "_Search"):edit,pause:recoll -t ~Search for what? :~
	nop
	exit:$(gettext "_Main menu")..

menu:help:$(gettext "Get Help with F123 Light"):$(gettext "Get Help with F123 Light")
	exec:$(gettext "_Chat Bot")::tt++ /etc/chatbot.tin
	nop
	exit:$(gettext "_Main menu")..

menu:power:$(gettext "Shutdown or Restart Your Computer"):$(gettext "Shutdown or restart your computer")
	exec:$(gettext "_Power Off")::poweroff &> /dev/null || sudo poweroff
	exec:$(gettext "_Restart")::reboot &> /dev/null || sudo reboot
	nop
	exit:$(gettext "_Main menu")..
EOF
