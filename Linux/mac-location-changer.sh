#!/bin/sh
# Change Mac's location based on the Wi-Fi you are connected to
# Copyright (C) 2020 Caleb Sargeant (scripts@calebsargeant.com)
# Permission to copy and modify is granted under this license: https://github.com/CalebSargeant/scripts/blob/master/LICENSE
# Last revised 2019

# Get the ssid of the network you are on
SSID=`/System/Library/PrivateFrameworks/Apple80211.framework/Resources/airport -I | awk -F: '/ SSID/{print $2}'`

#fill in your own values for ssid and location below
if [ $SSID = "Sargeant" ]
then
    LOCATION="Home"
    networksetup -setdnsservers Wi-Fi Empty
    dscacheutil -flushcache
    open -j -g 'smb://10.0.2.11/data'

elif [ $SSID = "KSYS" ]
then
    LOCATION="Work"
    networksetup -setdnsservers Wi-Fi 10.10.10.10
    ./hiole.sh
    dscacheutil -flushcache
else
    LOCATION="Automatic"
fi

#update the location
NEWLOC=`/usr/sbin/scselect ${LOCATION} | sed 's/^.*(\(.*\)).*$/\1/'`

echo ${NEWLOC}

#exit with error if the location didn't match what you expected
if [ ${LOCATION} != ${NEWLOC} ]
then
    exit 1
fi

exit 0
