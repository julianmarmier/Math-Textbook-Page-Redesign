#!/bin/bash
#Simple Bootable USB Drive Maker for Mac
#Author: ETCG (Epic Tin Can Games)

#Under MIT License:

#Copyright (c) 2016 ETCG
#Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
#The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
#THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#Variables:
ISOFILE="file.iso"
IMGFILE="file.img.dmg"
DIR="/tmp/etcg_drivemaker"
DISK="/dev/" #Will be updated later

#Main:
echo "To stop this script at any time, hit Control+C"
echo "Setting Up..."
sudo rm -r "$DIR" > /dev/null 2>&1 #Cleans up any old operations, to prevent any errors, and hides output
sudo mkdir "$DIR"
cd "$DIR"

echo "OS Choices:"
echo "  (A) Ubuntu 14.04.3 (64-bit)"
echo "  (B) Debian 8.3.0   (64-bit, internet installer)"
echo "  (C) Other          (You'll have to manually enter a URL)"
echo "  (D) Skip this step (You'll have to provide a path to the downloaded ISO.)"
echo "Please enter the letter corresponding with your choice (A, B, C, or D):"
read userOption

if [ "$userOption" == "A" ]; then
	DOWNLOADLINK="http://mirrors.mit.edu/ubuntu-releases/14.04.3/ubuntu-14.04.3-desktop-amd64.iso"
	echo "Downloading Ubuntu..."
	sudo curl "$DOWNLOADLINK" --output "$ISOFILE"
elif [ "$userOption" == "B" ]; then
	DOWNLOADLINK="caesar.acc.umu.se/debian-cd/8.3.0/amd64/iso-cd/debian-8.3.0-amd64-netinst.iso"
	echo "Downloading Debian..."
	sudo curl "$DOWNLOADLINK" --output "$ISOFILE"
elif [ "$userOption" == "C" ]; then
	echo "Please enter the ISO's URL, including the .iso:"
	read DOWNLOADLINK
	echo "Downloading the OS..."
	sudo curl "$DOWNLOADLINK" --output "$ISOFILE"
else
	echo "Please enter the ISO file's path (You can drag and drop the file here too):"
	read ISOPATH
	echo "Working..."
	cp "$ISOPATH" .
	ISOFILE="$(basename $ISOPATH)"	
fi

echo "Converting the ISO to the needed format..."
sudo hdiutil convert -format UDRW -o "$IMGFILE" "$ISOFILE"
echo "Please enter your drive's label (open Disk Utility, select your drive, and locate the value right of \"Device:\"):"
read LABEL
DISK+=$LABEL
echo "Unmounting Disk..."
diskutil unmountDisk "$DISK"
echo "About to make the bootable drive, this will erase all data on the drive"
echo "You have 20 seconds to abort...(abort by hitting \"Control\" and \"C\" at the same time)"
sleep 20
echo "Making Bootable Drive...(this will take a long time)"
sudo dd if="$IMGFILE" of="$DISK" bs=1m
echo "Drive Created!"
echo "Cleaning Up..."
sudo rm -r "$DIR"
echo "Done! Quiting..."
exit 0
