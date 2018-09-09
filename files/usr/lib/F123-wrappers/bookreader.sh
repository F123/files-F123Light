#!/bin/bash
# F123 book reader
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

# It is safe to assume one parameter here,as this script is to be run from a generated menu of books.
# In any case, we take only one parameter, even if this script runs from a file manager.
book=$1

# Each book type must be extracted using a different method.
# Determine the book type and its extraction method using its file extension.
type=${book##*.}

# Extract the book and pipe the result into w3m depending on its type
# New types may be added here at any time.
case $type in
	epub|Epub|EPUB) epub2txt -w 80 "$book" | w3m
	;;
	pdf|Pdf|PDF) pdftotext -layout "$book" - | w3m
	;;
	txt|Txt|TXT) w3m "$book"
	;;
	# Insert new formats above this line
	*) exit 1
	;;
esac
exit 0
