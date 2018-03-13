# MakeFile
# Description of functionality like: Automate Raspberry Pi image builds
# Take a config file on the command line and pass its options to the various stages of the build process
#
# Copyright 2018, F123 Consulting, <information@f123.org>
# Copyright 2018, Taha Zerrouki, <taha.zerrouki@gmail>
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



# test it
mishkal:
	git clone https://github.com/linuxscout/mishkal 
	echo "Install Mishkal arabic diacritizer "
	mkdir -p /opt/mishkal/
	chmod 777 -R /opt/mishkal
	cp -ur mishkal/* /opt/mishkal
	ln -f -s /opt/mishkal/bin/mishkal-console.py /usr/bin/mishkal
	chmod +x /usr/bin/mishkal
	echo "test mishkal"
	mishkal "السلام عليكم"
test-mishkal: test-espeak-mishkal test-mbrola-mishkal
test-espeak-mishkal:
	echo "test eSpeak with Mishkal"
	mishkal "السلام عليكم" | espeak-ng -v ar -w /tmp/test.wav |play /tmp/test.wav
test-mbrola-mishkal:
	echo "test Mrobla with Mishkal"
	mishkal "السلام عليكم" | espeak-ng -v mb-ar1  -w /tmp/testm.wav|play /tmp/testm.wav
#Section 3
# Test speech-dispatcher
# Configure Orca
dispatcher:
	echo "Configure Speech-idispatcher for a user"
	spd-conf
	echo " Add arabic special modules to speechd.conf"
	awk -i inplace -v  INPLACE_SUFFIX=.bak '1;/cicero/{ print " AddModule \"arabic-mbrola-generic\" \"sd_generic\" \"arabic-mbrola-generic.conf\"";}'  ~/.config/speech-dispatcher/speechd.conf
	awk -i inplace -v  INPLACE_SUFFIX=.bak '1;/cicero/{ print " AddModule \"arabic-generic\" \"sd_generic\" \"arabic-generic.conf\"";}'  ~/.config/speech-dispatcher/speechd.conf
	cp arabic-mbrola-generic.conf  ~/.config/speech-dispatcher/modules/arabic-mbrola-generic.conf
	cp arabic-generic.conf  ~/.config/speech-dispatcher/modules/arabic-generic.conf
	echo "restart spd-conf"
	spd-conf -D
test-disp: test-disp-espeak test-disp-mbrola
test-disp-espeak:
	rm  -f /run/user/1000/speech-dispatcher/log/arabic-generic.log 
	spd-say -o arabic-generic -l ar  "السلام عليكم"
test-disp-mbrola:
	rm  -f /run/user/1000/speech-dispatcher/log/arabic-mbrola-generic.log 
	spd-say -o arabic-mbrola-generic -l ar  "السلام عليكم"
testlog:
	tail /run/user/1000/speech-dispatcher/log/arabic-generic.log 
test-espeak:
	espeak -v ar  "السلام عليكم" -w /tmp/test.wav |play /tmp/test.wav
test-mbrola:
	espeak -v mb-ar1  "السلام عليكم" -w /tmp/test.wav |play /tmp/test.wav











