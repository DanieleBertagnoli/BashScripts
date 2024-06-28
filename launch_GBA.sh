#!/bin/bash

echo "Turning on tailscale"
sudo tailscale up

echo "Updating files..."
rsync -avzu -e "ssh -p 700" pi@100.82.7.120:~/Documents/GBA-Games/* ~/Documents/GBA-Games
rsync -avzu -e "ssh -p 700"  ~/Documents/GBA-Games/* pi@100.82.7.120:~/Documents/GBA-Games
echo "Files are up to date"

echo "Launch the GBA emulator"

mgba-qt

echo "Closing GBA emulator"

echo "Sending files to the server..."
rsync -avzu -e "ssh -p 700"  ~/Documents/GBA-Games/* pi@100.82.7.120:~/Documents/GBA-Games
echo "Thanks for using us!"