# user functions
# sourced by ~/bash_rc as shipped with F123Light
#
# Copyright 2018, F123 Consulting, <information@f123.org>
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
#--code--

change-passwords () {
	echo Changing passwords ...
	echo Start by changing the password you used to login.
	passwd

	cat <<-endOfText
		Now change the password of the administrator user called root. You usually won't need this password, but it does need to be memorable, as it will be used for recovery and other emergencies.
		You can also change this password even if you have forgotten the root password.
		First enter the password you just set up for your login user. Then you will be prompted for the root password.
	sudo passwd
}

configure-wifi () {
	# Runs the script to connect to a wireless network. Prompts for sudo privileges
	sudo -p "Connecting to a wireless network requires administrator privileges. Please enter your password to continue. " /usr/bin/configure-wifi
}
