#!/bin/bash

# Script to install classic tool menu on kali.
# Requires internet access.
# Made for my video on how to install Kali (without Virtual Box) on a Mac.

# Author  : ETCG
# Contact : Please go to my website, http://etcg.pw, for my contact details.
# Website : http://etcg.pw
# License : GPL


# Copyright (C) 2016 ETCG

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.


# First, let us check the internet connectivity
wget --spider http://example.com > /dev/null 2>&1
if [ "$?"=="0" ]
then
	echo "Internet connectivity appears to be working. Continuing..."
else
	echo "Internet appears to be down. Terminating..."
	exit 2
fi


# Root?
if [ "$EUID" -ne 0 ]
then
	echo "This program needs to be run as root:"
	echo "Try sudo $0"
	echo "If that doesn't work, try su <enter_key> $0"
	echo "In both cases, you should need to enter your password. You won't see it as you type."
	echo "Terminating..."
	exit 3
fi

# Install
add-apt-repository ppa:diesch/testing
apt update
apt install classicmenu-indicator -y

# Exit
echo "Installed the classic menu indicator. Goodbye."
exit