#!/bin/bash
# https://wiki.libreelec.tv/configuration/startup-shutdown
# This file lives in /storage/.config/autostart.sh

# Function to check if kodi.bin is running
is_kodi_running() {
    ps -A | grep kodi.bin | grep -v grep | wc -l
}

# Wait for kodi.bin or kodi to start
# Background the process
echo "Waiting for Kodi to start..."
(sleep 10
while ! is_kodi_running; do
    sleep 1
done)&

# Kodi is now running, send the command once
echo "Kodi detected. Sending command..."
kodi-send --action="playMedia(/storage/videos/cyclops.mov)" --action="PlayerControl(Repeat)"
