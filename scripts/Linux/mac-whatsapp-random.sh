#!/bin/bash
# Send a random message (from array) to specific person
# Copyright (C) 2020 Caleb Sargeant (scripts@calebsargeant.com)
# Permission to copy and modify is granted under this license: https://github.com/CalebSargeant/scripts/blob/master/LICENSE
# Last revised 2020-03-15

# Set the variables
TOKEN=REDACTED
WIFI=$(networksetup -getairportnetwork en0 | sed 's/.*: //')
MLIST=( \
    "Message 1" \
    "Message 2" \
    "Message 3" \
    "Message 4" \
)
M=${MLIST[ $(( RANDOM % ${#MLIST[@]} )) ] }

# Run the script only when at work
if [[ "$WIFI" == "WORK SSID" ]] ;
then
    whatsapp-cli --token $TOKEN send -u 'John Doe' -m "$M"
elif [[ "$WIFI" == "HOME SSID" ]] ;
then
    exit
    #exit
else
    exit
fi
