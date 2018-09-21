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
# Remember for subshells and variables that need to be sent instead of used put a backslash before the dollar sign
export TEXTDOMAIN=pdmenurc
export TEXTDOMAINDIR=/usr/share/locale
. gettext.sh

cat << EOF
title:$(gettext "Welcome to F123Light")

# Define the main menu.
menu:main:$(gettext "F123 Light Main Menu"):$(gettext "Use the up and down arrow keys to select your choice and press the 'Enter' key to activate it.")
	show:$(gettext "_Games Menu")..::games
	show:$(gettext "_Internet Menu")..:$(gettext "Browser, e-mail and chat applications"):internet
	show:$(gettext "_Media Menu")..:$(gettext "Book reading, music and video applications"):media
	show:$(gettext "_Office Menu")..:$(gettext "text, calendar and spreadsheet applications"):office
	exec:$(gettext "_File Manager"):$(gettext "Copy, move and delete files"):clear;mc -K /etc/mc/mc.keymap
	group:$(gettext "Manage External _Drives")
		exec::makemenu: \
		echo "menu:external:$(gettext "External"):$(gettext "Select Drive")"; \
		rmdir /media/* &> /dev/null; \
		c=0; \
		for i in \$(find /media -maxdepth 1 ! -path /media -type d) ; do \
			((c++)); \
			j="\${i/\/media\//}"; \
			echo "exec:_\$j::mc -K /etc/mc/mc.keymap '\$i'"; \
			echo "exec:$(gettext "Safely remove") _\$j::sudo umount '\$i'"; \
		done; \
		[[ \$c -gt 0 ]] && echo "exec:\$(gettext "No external drives found")::clear; \
		echo "exit:$(gettext "Main Menu").."
		show:::external
		remove:::external
	endgroup
	nop:$(gettext "Search")
    exec:$(gettext "Search This _Computer"):edit,pause:recoll -t ~Search for what? :~
    exec:$(gettext "Search the _Web"):edit,pause:google ~Search for what? :~
	nop
	show:$(gettext "_Settings Menu")..:$(gettext "Configure this computer"):settings
	show:$(gettext "_Help Menu")..:$(gettext "Get Help with F123Light"):help
	show:$(gettext "_Turn Off or Restart Computer")..::power
	nop
	exit:$(gettext "E_xit to Command Line")

# Submenu for games.
menu:games:$(gettext "Games")):
	exec:$(gettext "_Adventure"):pause:clear;command $([[ $DEMOMODE ]] && echo -n '-v') adventure
	exec:$(gettext "_Arithmetic Challenge!"):pause:clear;command $([[ $DEMOMODE ]] && echo -n '-v') arithmetic
	#exec:$(gettext "_Air Traffic Controler (Not screen reader friendly)")::clear;command $([[ $DEMOMODE ]] && echo '-v') atc
	#exec:$(gettext "_Backgammon (Not screen reader friendly)")::clear;command $([[ $DEMOMODE ]] && echo '-v') backgammon
	exec:$(gettext "_Battlestar")::clear;command $([[ $DEMOMODE ]] && echo '-v') battlestar
	#exec:$(gettext "_Boggle (Not screen reader friendly)")::clear;command $([[ $DEMOMODE ]] && echo '-v') boggle
	#exec:$(gettext "_Canfield (Not screen reader friendly)")::clear;command $([[ $DEMOMODE ]] && echo '-v') canfield
	#exec:$(gettext "_Cribbage (Not screen reader friendly)")::clear;command $([[ $DEMOMODE ]] && echo '-v') cribbage
	exec:$(gettext "_Go Fish"):pause:clear;command $([[ $DEMOMODE ]] && echo '-v') go-fish
	exec:$(gettext "_Gomoku")::clear;command $([[ $DEMOMODE ]] && echo '-v') gomoku
	exec:$(gettext "_Hangman")::clear;command $([[ $DEMOMODE ]] && echo '-v') hangman
	#exec:$(gettext "_Hunt (Not screen reader friendly)")::clear;command $([[ $DEMOMODE ]] && echo '-v') hunt
	exec:$(gettext "_Mille Bornes")::clear;command $([[ $DEMOMODE ]] && echo '-v') mille
	exec:$(gettext "_Number")::clear;command $([[ $DEMOMODE ]] && echo '-v') number
	exec:$(gettext "_Phantasia")::clear;command $([[ $DEMOMODE ]] && echo '-v') phantasia
	exec:$(gettext "_Phase of the Moon"):pause:clear;command $([[ $DEMOMODE ]] && echo '-v') pom
	exec:$(gettext "_Primes")::clear;command $([[ $DEMOMODE ]] && echo '-v') primes
	#exec:$(gettext "_Robots (Not screen reader friendly)")::clear;command $([[ $DEMOMODE ]] && echo '-v') robots
	exec:$(gettext "_Sail")::clear;command $([[ $DEMOMODE ]] && echo '-v') sail
	#exec:$(gettext "_Snake (Not screen reader friendly)")::clear;command $([[ $DEMOMODE ]] && echo '-v') snake
	#exec:$(gettext "_Tetris (Not screen reader friendly)")::clear;command $([[ $DEMOMODE ]] && echo '-v') tetris-bsd
	exec:$(gettext "_Trek")::clear;command $([[ $DEMOMODE ]] && echo '-v') trek
	group:$(gettext "_Tux Math")
        exec:::clear
        exec:::python /usr/share/fenrirscreenreader/tools/fenrir-ignore-screen
        exec:::echo -n "setting set screen#suspendingScreen=\$(</tmp/fenrirSuspend)" | socat - UNIX-CLIENT:/tmp/fenrirscreenreader-deamon.sock
        exec:::startx /usr/lib/F123-wrappers/tuxmath --tts
        exec:::python /usr/share/fenrirscreenreader/tools/fenrir-unignore-screen
        exec:::echo -n "setting set screen#suspendingScreen=\$(</tmp/fenrirSuspend)" | socat - UNIX-CLIENT:/tmp/fenrirscreenreader-deamon.sock
    endgroup
	group:$(gettext "_Tux Type")
        exec:::clear
        exec:::python /usr/share/fenrirscreenreader/tools/fenrir-ignore-screen
        exec:::echo -n "setting set screen#suspendingScreen=\$(</tmp/fenrirSuspend)" | socat - UNIX-CLIENT:/tmp/fenrirscreenreader-deamon.sock
        exec:::startx /usr/lib/F123-wrappers/tuxtype --tts
        exec:::python /usr/share/fenrirscreenreader/tools/fenrir-unignore-screen
        exec:::echo -n "setting set screen#suspendingScreen=\$(</tmp/fenrirSuspend)" | socat - UNIX-CLIENT:/tmp/fenrirscreenreader-deamon.sock
    endgroup
	#exec:$(gettext "_Worm (Not screen reader friendly)")::clear;command $([[ $DEMOMODE ]] && echo '-v') worm
	exec:$(gettext "_Wumpus")::clear;command $([[ $DEMOMODE ]] && echo '-v') wump
	nop
	exit:$(gettext "Main Menu")..

# submenu for internet applications.
menu:internet:$(gettext "Internet"):$(gettext "Internet programs")
	group:$(gettext "_E-_mail (Thunderbird)")
        exec:::clear
        exec:::python /usr/share/fenrirscreenreader/tools/fenrir-ignore-screen
        exec:::echo -n "setting set screen#suspendingScreen=\$(</tmp/fenrirSuspend)" | socat - UNIX-CLIENT:/tmp/fenrirscreenreader-deamon.sock
        exec:::startx /usr/lib/F123-wrappers/xlauncher thunderbird
        exec:::python /usr/share/fenrirscreenreader/tools/fenrir-unignore-screen
        exec:::echo -n "setting set screen#suspendingScreen=\$(</tmp/fenrirSuspend)" | socat - UNIX-CLIENT:/tmp/fenrirscreenreader-deamon.sock
    endgroup
	nop:$(gettext "Web Browsers")
	exec:$(gettext "_Basic Web Browser (W3M)")::clear;command $([[ $DEMOMODE ]] && echo '-v') w3m
	group:$(gettext "_Full Web Browser (Firefox)")
        exec:::clear
        exec:::python /usr/share/fenrirscreenreader/tools/fenrir-ignore-screen
        exec:::echo -n "setting set screen#suspendingScreen=\$(</tmp/fenrirSuspend)" | socat - UNIX-CLIENT:/tmp/fenrirscreenreader-deamon.sock
        exec:::startx /usr/lib/F123-wrappers/xlauncher firefox
        exec:::python /usr/share/fenrirscreenreader/tools/fenrir-unignore-screen
        exec:::echo -n "setting set screen#suspendingScreen=\$(</tmp/fenrirSuspend)" | socat - UNIX-CLIENT:/tmp/fenrirscreenreader-deamon.sock
    endgroup
	nop:$(gettext "Communication")
	group:$(gettext "_Text Chat (Pidgin)")
        exec:::clear
        exec:::python /usr/share/fenrirscreenreader/tools/fenrir-ignore-screen
        exec:::echo -n "setting set screen#suspendingScreen=\$(</tmp/fenrirSuspend)" | socat - UNIX-CLIENT:/tmp/fenrirscreenreader-deamon.sock
        exec:::startx /usr/lib/F123-wrappers/xlauncher pidgin
        exec:::python /usr/share/fenrirscreenreader/tools/fenrir-unignore-screen
        exec:::echo -n "setting set screen#suspendingScreen=\$(</tmp/fenrirSuspend)" | socat - UNIX-CLIENT:/tmp/fenrirscreenreader-deamon.sock
    endgroup
	group:$(gettext "_Voice Chat (Mumble)")
        exec:::clear
        exec:::python /usr/share/fenrirscreenreader/tools/fenrir-ignore-screen
        exec:::echo -n "setting set screen#suspendingScreen=\$(</tmp/fenrirSuspend)" | socat - UNIX-CLIENT:/tmp/fenrirscreenreader-deamon.sock
        exec:::startx /usr/lib/F123-wrappers/xlauncher mumble
        exec:::python /usr/share/fenrirscreenreader/tools/fenrir-unignore-screen
        exec:::echo -n "setting set screen#suspendingScreen=\$(</tmp/fenrirSuspend)" | socat - UNIX-CLIENT:/tmp/fenrirscreenreader-deamon.sock
    endgroup
	nop
	exit:$(gettext "_Main Menu")..

menu:media:$(gettext "Media"):$(gettext "Multi-media applications")
	exec:$(gettext "_CD Audio Ripper (ripit)")::command $([[ $DEMOMODE ]] && echo '-v') ripit
	exec:$(gettext "_Music Player (cmus)")::command $([[ $DEMOMODE ]] && echo '-v') cmus
	exec:$(gettext "_Stringed Instrument Tuner (bashtuner)")::command $([[ $DEMOMODE ]] && echo '-v') bashtuner
	exec:$(gettext "Youtube (_Audio Only)")::command $([[ $DEMOMODE ]] && echo '-v') youtube-viewer -novideo
	group:$(gettext "Youtube (Full _Video)")
        exec:::clear
        exec:::python /usr/share/fenrirscreenreader/tools/fenrir-ignore-screen
        exec:::echo -n "setting set screen#suspendingScreen=\$(</tmp/fenrirSuspend)" | socat - UNIX-CLIENT:/tmp/fenrirscreenreader-deamon.sock
        exec:::startx /usr/lib/F123-wrappers/xlauncher lxterminal -e youtube-viewer
        exec:::python /usr/share/fenrirscreenreader/tools/fenrir-unignore-screen
        exec:::echo -n "setting set screen#suspendingScreen=\$(</tmp/fenrirSuspend)" | socat - UNIX-CLIENT:/tmp/fenrirscreenreader-deamon.sock
    endgroup
	nop:$(gettext "Book Readers")
	group:$(gettext "_Book Reader")
		exec::makemenu: \
		echo "menu:books:$(gettext "Books"):$(gettext "Select book to read")"; \
		find \$HOME -type f \( -iname "*.epub" -o -iname "*.pdf" -o -iname "*.txt" -o -iname "*.html" \) -print0 |\
		 while read -d \$'\0' i ; do \
			j="\$(basename "\$i")"; \
			echo "exec:_\${j%%.*}::/usr/lib/F123-wrappers/bookreader.sh '\$i'"; \
		done; \
		echo nop; \
		echo "exit:$(gettext "Media Menu").."
		show:::books
		remove:::books
	endgroup
	nop
	exit:$(gettext "_Main Menu")..

menu:office:$(gettext "Office"):$(gettext "Word processing, calendar, etc")
	exec:$(gettext "_Month Calendar"):pause:clear;command $([[ $DEMOMODE ]] && echo '-v') ncal
	exec:$(gettext "_Year Calendar"):pause:clear;command $([[ $DEMOMODE ]] && echo '-v') ncal -y
	exec:$(gettext "_Text Editor")::clear;command $([[ $DEMOMODE ]] && echo '-v') ${EDITOR:-nano}
	nop:$(gettext "Office Suite")
	group:$(gettext "_Spreadsheet")
        exec:::clear
        exec:::python /usr/share/fenrirscreenreader/tools/fenrir-ignore-screen
        exec:::echo -n "setting set screen#suspendingScreen=\$(</tmp/fenrirSuspend)" | socat - UNIX-CLIENT:/tmp/fenrirscreenreader-deamon.sock
        exec:::startx /usr/lib/F123-wrappers/xlauncher localc
        exec:::python /usr/share/fenrirscreenreader/tools/fenrir-unignore-screen
        exec:::echo -n "setting set screen#suspendingScreen=\$(</tmp/fenrirSuspend)" | socat - UNIX-CLIENT:/tmp/fenrirscreenreader-deamon.sock
    endgroup
	group:$(gettext "_Word Processor")
        exec:::clear
        exec:::python /usr/share/fenrirscreenreader/tools/fenrir-ignore-screen
        exec:::echo -n "setting set screen#suspendingScreen=\$(</tmp/fenrirSuspend)" | socat - UNIX-CLIENT:/tmp/fenrirscreenreader-deamon.sock
        exec:::startx /usr/lib/F123-wrappers/xlauncher lowriter
        exec:::python /usr/share/fenrirscreenreader/tools/fenrir-unignore-screen
        exec:::echo -n "setting set screen#suspendingScreen=\$(</tmp/fenrirSuspend)" | socat - UNIX-CLIENT:/tmp/fenrirscreenreader-deamon.sock
    endgroup
	group:$(gettext "_Libre Office (All Applications)")
        exec:::clear
        exec:::python /usr/share/fenrirscreenreader/tools/fenrir-ignore-screen
        exec:::echo -n "setting set screen#suspendingScreen=\$(</tmp/fenrirSuspend)" | socat - UNIX-CLIENT:/tmp/fenrirscreenreader-deamon.sock
        exec:::startx /usr/lib/F123-wrappers/xlauncher soffice
        exec:::python /usr/share/fenrirscreenreader/tools/fenrir-unignore-screen
        exec:::echo -n "setting set screen#suspendingScreen=\$(</tmp/fenrirSuspend)" | socat - UNIX-CLIENT:/tmp/fenrirscreenreader-deamon.sock
    endgroup
	nop
	exit:$(gettext "_Main Menu")..

# submenu for configuring the computer.
menu:settings:$(gettext "Settings"):$(gettext "System configuration")
	exec:$(gettext "_Change Passwords")::clear;/usr/lib/F123-wrappers/configure-passwords
	exec:$(gettext "E-_mail Configuration")::clear;command $([[ $DEMOMODE ]] && echo '-v') fleacollar
	exec:$(gettext "Securit_y Configuration")::clear;/usr/lib/F123-wrappers/configure-security.sh
	exec:$(gettext "Change System S_peech")::clear;/usr/lib/F123-wrappers/configure-speech.sh
	exec:$(gettext "Change _Sound Output")::clear;/usr/lib/F123-wrappers/configure-sound.sh
	#group:$(gettext "_Bluetooth manager")
        #exec:::clear
        #exec:::python /usr/share/fenrirscreenreader/tools/fenrir-ignore-screen
        #exec:::echo -n "setting set screen#suspendingScreen=\$(</tmp/fenrirSuspend)" | socat - UNIX-CLIENT:/tmp/fenrirscreenreader-deamon.sock
        #exec:::startx /usr/lib/F123-wrappers/xlauncher blueman-assistant
        #exec:::python /usr/share/fenrirscreenreader/tools/fenrir-unignore-screen
        #exec:::echo -n "setting set screen#suspendingScreen=\$(</tmp/fenrirSuspend)" | socat - UNIX-CLIENT:/tmp/fenrirscreenreader-deamon.sock
    #endgroup
	exec:$(gettext "Configure _Wifi")::clear;sudo configure-wifi
	nop
	exit:$(gettext "_Main Menu")..

menu:help:$(gettext "Get Help with F123 Light"):$(gettext "Get Help with F123Light")
	exec:$(gettext "_Chat Bot")::command $([[ $DEMOMODE ]] && echo '-v') /usr/bin/chatbot-client
	nop
	exit:$(gettext "_Main Menu")..

menu:power:$(gettext "Turn off or Restart Computer"):$(gettext "Shutdown or restart your computer")
	exec:$(gettext "Turn _Off")::poweroff &> /dev/null || sudo poweroff
	exec:$(gettext "_Restart")::reboot &> /dev/null || sudo reboot
	nop
	exit:$(gettext "_Main Menu")..
EOF
