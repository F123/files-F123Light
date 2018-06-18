#!/bin/bash
# reminders
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

for i in /usr/lib/F123-includes/*.sh ; do
    source "$i"
done

clear_calendar() {
    [[ -f "$HOME/calendar" ]] && {
        rm "$HOME/calendar";
        msgbox "All reminders deleted.";
    } ||  msgbox "No reminders found."
}

while [[ "$choice" != "exit" ]]; do
    choice="$(menulist "Add Reminder" "Add something to your calendar" "Remove Reminder" "Remove something from your reminders" "Clear Reminders" "Remove everything from your reminders" "Exit" "Close this app")"
    choice="${choice,,}"
    choice="${choice// /_}"
    if [[ "$choice" != "exit" && "$choice" != "" ]]; then
        eval "$choice"
    else
        break
    fi
done
exit 0
