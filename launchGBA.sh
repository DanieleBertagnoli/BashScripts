#!/bin/bash

echo "Turning on tailscale"
sudo tailscale up

echo "Updating files..."
#scp files from rasp
echo "Files are up to date"

echo "Launch the GBA emulatore"

mgba-qt

echo "Closing GBA emulator"

echo "Sending files to the server..."
#scp to rasp
echo "Thanks for using us!"