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
	show:$(gettext "_Games Menu (G)")..::games
	show:$(gettext "_Internet Menu (I)")..:$(gettext "Browser, e-mail and chat applications"):internet
	show:$(gettext "_Media Menu (M)")..:$(gettext "Book reading, music and video applications"):media
	show:$(gettext "_Office Menu (O)")..:$(gettext "text, calendar and spreadsheet applications"):office
	exec:$(gettext "_File Manager (F)"):$(gettext "Copy, move and delete files"):clear;command $([[ -n $DEMOMODE ]] && echo '-v') filestorm
	group:$(gettext "Manage External _Drives (D)")
		exec::makemenu: \
		echo "menu:external:$(gettext "External"):$(gettext "Select Drive")"; \
		if [ -z $DEMOMODE ]; then \
		rmdir /media/* &> /dev/null; \
		c=0; \
		for i in \$(find /media -maxdepth 1 ! -path /media -type d 2> /dev/null) ; do \
			((c++)); \
			j="\${i/\/media\//}"; \
			echo "exec:_\$j::filestorm '\$i'"; \
			echo "exec:$(gettext "Safely remove") _\$j::sudo umount '\$i'"; \
		done; \
		[[ \$c -gt 0 ]] || echo "exec:\$(gettext "No external drives found")::clear"; \
		echo "exit:$(gettext "Main Menu").."; \
	fi
		show:::external
		remove:::external
	endgroup
	nop:$(gettext "Search")
    exec:$(gettext "Search This _Computer (C)"):edit,pause:command $([[ -n $DEMOMODE ]] && echo '-v') recoll -t ~Search for what? :~
    exec:$(gettext "Search the _Web (W)"):edit,pause:command $([[ -n $DEMOMODE ]] && echo '-v') ${preferences[searchEngine]} ~Search for what? :~
	nop
	show:$(gettext "_Settings Menu (S)")..:$(gettext "Configure this computer"):settings
	show:$(gettext "_Help Menu (H)")..:$(gettext "Get Help with F123Light"):help
	show:$(gettext "_Turn Off or Restart Computer (T)")..::power
	nop
	exit:$(gettext "E_xit to Command Line")

# Submenu for games.
menu:games:$(gettext "Games")):
	exec:$(gettext "_Adventure (A)"):pause:clear;command $([[ -n $DEMOMODE ]] && echo -n '-v') adventure
	exec:$(gettext "_Arithmetic Challenge! (A)"):pause:clear;command $([[ -n $DEMOMODE ]] && echo -n '-v') arithmetic
	#exec:$(gettext "_Air Traffic Controler (Not screen reader friendly) (A)")::clear;command $([[ -n $DEMOMODE ]] && echo '-v') atc
	#exec:$(gettext "_Backgammon (Not screen reader friendly) (B)")::clear;command $([[ -n $DEMOMODE ]] && echo '-v') backgammon
	exec:$(gettext "_Battlestar (B)")::clear;command $([[ -n $DEMOMODE ]] && echo '-v') battlestar
	#exec:$(gettext "_Boggle (Not screen reader friendly) (B)")::clear;command $([[ -n $DEMOMODE ]] && echo '-v') boggle
	#exec:$(gettext "_Canfield (Not screen reader friendly) (C)")::clear;command $([[ -n $DEMOMODE ]] && echo '-v') canfield
	#exec:$(gettext "_Cribbage (Not screen reader friendly) (C)")::clear;command $([[ -n $DEMOMODE ]] && echo '-v') cribbage
	exec:$(gettext "_Go Fish (G)"):pause:clear;command $([[ -n $DEMOMODE ]] && echo '-v') go-fish
	exec:$(gettext "_Gomoku (G)")::clear;command $([[ -n $DEMOMODE ]] && echo '-v') gomoku
	exec:$(gettext "_Hangman (H)")::clear;command $([[ -n $DEMOMODE ]] && echo '-v') hangman
	#exec:$(gettext "_Hunt (Not screen reader friendly) (H)")::clear;command $([[ -n $DEMOMODE ]] && echo '-v') hunt
	exec:$(gettext "Legends of _Kallisti (K)")::clear;command $([[ -n $DEMOMODE ]] && echo '-v') /usr/lib/F123-wrappers/mud-loader.sh https://gitlab.com/hjozwiak/tintin-kallisti-pack.git
	exec:$(gettext "_Mille Bornes (M)")::clear;command $([[ -n $DEMOMODE ]] && echo '-v') mille
	exec:$(gettext "_Number (N)")::clear;command $([[ -n $DEMOMODE ]] && echo '-v') number
	exec:$(gettext "_Phantasia (P)")::clear;command $([[ -n $DEMOMODE ]] && echo '-v') phantasia
	exec:$(gettext "_Phase of the Moon (P)"):pause:clear;command $([[ -n $DEMOMODE ]] && echo '-v') pom
	exec:$(gettext "_Primes (P)")::clear;command $([[ -n $DEMOMODE ]] && echo '-v') primes
	#exec:$(gettext "_Robots (Not screen reader friendly) (R)")::clear;command $([[ -n $DEMOMODE ]] && echo '-v') robots
	exec:$(gettext "_Sail (S)")::clear;command $([[ -n $DEMOMODE ]] && echo '-v') sail
	#exec:$(gettext "_Snake (Not screen reader friendly) (S)")::clear;command $([[ -n $DEMOMODE ]] && echo '-v') snake
	#exec:$(gettext "_Tetris (Not screen reader friendly) (T)")::clear;command $([[ -n $DEMOMODE ]] && echo '-v') tetris-bsd
	exec:$(gettext "_Trek (T)")::clear;command $([[ -n $DEMOMODE ]] && echo '-v') trek
	group:$(gettext "_Tux Math (T)")
        exec:::clear
        exec:::python /usr/share/fenrirscreenreader/tools/fenrir-ignore-screen &> /dev/null
        exec:::echo -n "setting set screen#suspendingScreen=\$(</tmp/fenrirSuspend)" | socat - UNIX-CLIENT:/tmp/fenrirscreenreader-deamon.sock
        exec:::command $([[ -n $DEMOMODE ]] && echo '-v') startx /usr/lib/F123-wrappers/tuxmath --tts
        exec:::python /usr/share/fenrirscreenreader/tools/fenrir-unignore-screen &> /dev/null
        exec:::echo -n "setting set screen#suspendingScreen=\$(</tmp/fenrirSuspend)" | socat - UNIX-CLIENT:/tmp/fenrirscreenreader-deamon.sock
    endgroup
	group:$(gettext "_Tux Type (T)")
        exec:::clear
        exec:::python /usr/share/fenrirscreenreader/tools/fenrir-ignore-screen &> /dev/null
        exec:::echo -n "setting set screen#suspendingScreen=\$(</tmp/fenrirSuspend)" | socat - UNIX-CLIENT:/tmp/fenrirscreenreader-deamon.sock
        exec:::command $([[ -n $DEMOMODE ]] && echo '-v') startx /usr/lib/F123-wrappers/tuxtype --tts
        exec:::python /usr/share/fenrirscreenreader/tools/fenrir-unignore-screen &> /dev/null
        exec:::echo -n "setting set screen#suspendingScreen=\$(</tmp/fenrirSuspend)" | socat - UNIX-CLIENT:/tmp/fenrirscreenreader-deamon.sock
    endgroup
	#exec:$(gettext "_Worm (Not screen reader friendly) (W)")::clear;command $([[ -n $DEMOMODE ]] && echo '-v') worm
	exec:$(gettext "_Wumpus (W)")::clear;command $([[ -n $DEMOMODE ]] && echo '-v') wump
	nop
	exit:$(gettext "_Main Menu (M)")..

# submenu for internet applications.
menu:internet:$(gettext "Internet"):$(gettext "Internet programs")
	group:$(gettext "E-_mail (M)")
        $(/usr/lib/F123-wrappers/mail-launcher.sh)
    endgroup
	nop:$(gettext "Web Browsers")
	exec:$(gettext "_Basic Web Browser (W3M) (B)")::clear;command $([[ -n $DEMOMODE ]] && echo '-v') w3m
	group:$(gettext "_Full Web Browser (Firefox) (F)")
        exec:::clear
        exec:::python /usr/share/fenrirscreenreader/tools/fenrir-ignore-screen &> /dev/null
        exec:::echo -n "setting set screen#suspendingScreen=\$(</tmp/fenrirSuspend)" | socat - UNIX-CLIENT:/tmp/fenrirscreenreader-deamon.sock
        exec:::command $([[ -n $DEMOMODE ]] && echo '-v') startx /usr/lib/F123-wrappers/xlauncher firefox
        exec:::python /usr/share/fenrirscreenreader/tools/fenrir-unignore-screen &> /dev/null
        exec:::echo -n "setting set screen#suspendingScreen=\$(</tmp/fenrirSuspend)" | socat - UNIX-CLIENT:/tmp/fenrirscreenreader-deamon.sock
    endgroup
	nop:$(gettext "Communication")
	exec:$(gettext "Google _Hangouts (H)")::clear;command $([[ -n $DEMOMODE ]] && echo '-v') hangups
	group:$(gettext "_Text Chat (Pidgin) (T)")
        exec:::clear
        exec:::python /usr/share/fenrirscreenreader/tools/fenrir-ignore-screen &> /dev/null
        exec:::echo -n "setting set screen#suspendingScreen=\$(</tmp/fenrirSuspend)" | socat - UNIX-CLIENT:/tmp/fenrirscreenreader-deamon.sock
        exec:::command $([[ -n $DEMOMODE ]] && echo '-v') startx /usr/lib/F123-wrappers/xlauncher pidgin
        exec:::python /usr/share/fenrirscreenreader/tools/fenrir-unignore-screen &> /dev/null
        exec:::echo -n "setting set screen#suspendingScreen=\$(</tmp/fenrirSuspend)" | socat - UNIX-CLIENT:/tmp/fenrirscreenreader-deamon.sock
    endgroup
	group:$(gettext "_Voice Chat (Mumble) (V)")
        exec:::clear
        exec:::python /usr/share/fenrirscreenreader/tools/fenrir-ignore-screen &> /dev/null
        exec:::echo -n "setting set screen#suspendingScreen=\$(</tmp/fenrirSuspend)" | socat - UNIX-CLIENT:/tmp/fenrirscreenreader-deamon.sock
        exec:::command $([[ -n $DEMOMODE ]] && echo '-v') startx /usr/lib/F123-wrappers/xlauncher mumble
        exec:::python /usr/share/fenrirscreenreader/tools/fenrir-unignore-screen &> /dev/null
        exec:::echo -n "setting set screen#suspendingScreen=\$(</tmp/fenrirSuspend)" | socat - UNIX-CLIENT:/tmp/fenrirscreenreader-deamon.sock
    endgroup
	nop
	exit:$(gettext "_Main Menu (M)")..

menu:media:$(gettext "Media"):$(gettext "Multi-media applications")
	exec:$(gettext "CD _Audio Ripper (A)")::command $([[ -n $DEMOMODE ]] && echo '-v') ripit
	exec:$(gettext "_Music Player (M)")::command $([[ -n $DEMOMODE ]] && echo '-v') cmus
	exec:$(gettext "Stringed _Instrument Tuner (I)")::command $([[ -n $DEMOMODE ]] && echo '-v') bashtuner
	group:$(gettext "_Pandora Internet Radio (P)")
        exec:::clear
        exec:::test -d "${XDG_CONFIG_HOME:-$HOME/.config}/pianobar" || command $([[ -n $DEMOMODE ]] && echo '-v') /usr/lib/F123-wrappers/configure-pianobar.sh
        exec:::command $([[ -n $DEMOMODE ]] && echo '-v') pianobar
    endgroup
	exec:$(gettext "Youtube (_Audio Only) (A)")::command $([[ -n $DEMOMODE ]] && echo '-v') youtube-viewer -novideo
	group:$(gettext "Youtube (Full _Video) (V)")
        exec:::clear
        exec:::python /usr/share/fenrirscreenreader/tools/fenrir-ignore-screen &> /dev/null
        exec:::echo -n "setting set screen#suspendingScreen=\$(</tmp/fenrirSuspend)" | socat - UNIX-CLIENT:/tmp/fenrirscreenreader-deamon.sock
        exec:::command $([[ -n $DEMOMODE ]] && echo '-v') startx /usr/lib/F123-wrappers/xlauncher lxterminal -e youtube-viewer
        exec:::python /usr/share/fenrirscreenreader/tools/fenrir-unignore-screen &> /dev/null
        exec:::echo -n "setting set screen#suspendingScreen=\$(</tmp/fenrirSuspend)" | socat - UNIX-CLIENT:/tmp/fenrirscreenreader-deamon.sock
    endgroup
	nop:$(gettext "Book Readers")
	group:$(gettext "_Book Reader (B)")
		exec::makemenu: \
		echo "menu:books:$(gettext "Books"):$(gettext "Select book to read")"; \
		if [ -z "$DEMOMODE" ]; then \
		find \$HOME -type f \( -iname "*.epub" -o -iname "*.pdf" -o -iname "*.txt" -o -iname "*.html" \) -print0 |\
		 while read -d \$'\0' i ; do \
			j="\$(basename "\$i")"; \
			echo "exec:_\${j%%.*}::/usr/lib/F123-wrappers/bookreader.sh '\$i'"; \
		done; \
		echo nop; \
		echo "exit:$(gettext "Media Menu").."; \
		fi
		show:::books
		remove:::books
	endgroup
	nop
	exit:$(gettext "_Main Menu (M)")..

menu:office:$(gettext "Office"):$(gettext "Word processing, calendar, etc")
	exec:$(gettext "_Month Calendar (M)"):pause:clear;command $([[ -n $DEMOMODE ]] && echo '-v') ncal
	exec:$(gettext "_Year Calendar (Y)"):pause:clear;command $([[ -n $DEMOMODE ]] && echo '-v') ncal -y
	exec:$(gettext "_Spreadsheet (S)")::clear;command $([[ -n $DEMOMODE ]] && echo '-v') sc-im
	exec:$(gettext "_Text Editor (T)")::clear;command $([[ -n $DEMOMODE ]] && echo '-v') ${EDITOR:-nano}
	exec:$(gettext "_Word Processor (W)")::clear;command $([[ -n $DEMOMODE ]] && echo '-v') wordgrinder
	nop:$(gettext "Office Suite")
	group:$(gettext "_Spreadsheet (S)")
        exec:::clear
        exec:::python /usr/share/fenrirscreenreader/tools/fenrir-ignore-screen &> /dev/null
        exec:::echo -n "setting set screen#suspendingScreen=\$(</tmp/fenrirSuspend)" | socat - UNIX-CLIENT:/tmp/fenrirscreenreader-deamon.sock
        exec:::command $([[ -n $DEMOMODE ]] && echo '-v') startx /usr/lib/F123-wrappers/xlauncher localc
        exec:::python /usr/share/fenrirscreenreader/tools/fenrir-unignore-screen &> /dev/null
        exec:::echo -n "setting set screen#suspendingScreen=\$(</tmp/fenrirSuspend)" | socat - UNIX-CLIENT:/tmp/fenrirscreenreader-deamon.sock
    endgroup
	group:$(gettext "_Word Processor (W)")
        exec:::clear
        exec:::python /usr/share/fenrirscreenreader/tools/fenrir-ignore-screen &> /dev/null
        exec:::echo -n "setting set screen#suspendingScreen=\$(</tmp/fenrirSuspend)" | socat - UNIX-CLIENT:/tmp/fenrirscreenreader-deamon.sock
        exec:::command $([[ -n $DEMOMODE ]] && echo '-v') startx /usr/lib/F123-wrappers/xlauncher lowriter
        exec:::python /usr/share/fenrirscreenreader/tools/fenrir-unignore-screen &> /dev/null
        exec:::echo -n "setting set screen#suspendingScreen=\$(</tmp/fenrirSuspend)" | socat - UNIX-CLIENT:/tmp/fenrirscreenreader-deamon.sock
    endgroup
	group:$(gettext "Libre _Office (All Applications) (O)")
        exec:::clear
        exec:::python /usr/share/fenrirscreenreader/tools/fenrir-ignore-screen &> /dev/null
        exec:::echo -n "setting set screen#suspendingScreen=\$(</tmp/fenrirSuspend)" | socat - UNIX-CLIENT:/tmp/fenrirscreenreader-deamon.sock
        exec:::command $([[ -n $DEMOMODE ]] && echo '-v') startx /usr/lib/F123-wrappers/xlauncher soffice
        exec:::python /usr/share/fenrirscreenreader/tools/fenrir-unignore-screen &> /dev/null
        exec:::echo -n "setting set screen#suspendingScreen=\$(</tmp/fenrirSuspend)" | socat - UNIX-CLIENT:/tmp/fenrirscreenreader-deamon.sock
    endgroup
	nop
	exit:$(gettext "_Main Menu (M)")..

# submenu for configuring the computer.
menu:settings:$(gettext "Settings"):$(gettext "System configuration")
	exec:$(gettext "Check for System _Updates (U)"):pause:clear;/usr/bin/update-f123light
	exec:$(gettext "_Change Passwords (C)")::clear;/usr/lib/F123-wrappers/configure-passwords.sh
	exec:$(gettext "E-_mail Configuration (M)")::clear;command $([[ -n $DEMOMODE ]] && echo '-v') configure-email
	exec:$(gettext "Securit_y Configuration (Y)")::clear;/usr/lib/F123-wrappers/configure-security.sh
	exec:$(gettext "Change System S_peech (P)")::clear;/usr/lib/F123-wrappers/configure-speech.sh
	exec:$(gettext "Change _Sound Output (S)")::clear;/usr/lib/F123-wrappers/configure-sound.sh
	#group:$(gettext "_Bluetooth manager (B)")
        #exec:::clear
        #exec:::python /usr/share/fenrirscreenreader/tools/fenrir-ignore-screen &> /dev/null
        #exec:::echo -n "setting set screen#suspendingScreen=\$(</tmp/fenrirSuspend)" | socat - UNIX-CLIENT:/tmp/fenrirscreenreader-deamon.sock
        #exec:::command $([[ -n $DEMOMODE ]] && echo '-v') startx /usr/lib/F123-wrappers/xlauncher blueman-assistant
        #exec:::python /usr/share/fenrirscreenreader/tools/fenrir-unignore-screen &> /dev/null
        #exec:::echo -n "setting set screen#suspendingScreen=\$(</tmp/fenrirSuspend)" | socat - UNIX-CLIENT:/tmp/fenrirscreenreader-deamon.sock
    #endgroup
	exec:$(gettext "Configure _Wifi (W)")::clear;sudo configure-wifi
	nop
	exit:$(gettext "_Main Menu (M)")..

menu:help:$(gettext "Get Help with F123 Light"):$(gettext "Get Help with F123Light")
	exec:$(gettext "_Get Help (G)"):pause:command $([[ -n $DEMOMODE ]] && echo '-v') echo -e "For help please subscribe to the F123 visual email list\nhttps://groups.io/g/F123-Visual-English"
	nop
	exit:$(gettext "_Main Menu")..

menu:power:$(gettext "Turn off or Restart Computer"):$(gettext "Shutdown or restart your computer")
	exec:$(gettext "_Lock (L)")::vlock -a
	exec:$(gettext "Turn _Off (O)")::poweroff &> /dev/null || sudo poweroff
	exec:$(gettext "_Restart (R)")::reboot &> /dev/null || sudo reboot
	nop
	exit:$(gettext "_Main Menu (M)")..
EOF
