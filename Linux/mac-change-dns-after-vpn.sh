#!/bin/bash
# Script to statically set DNS server after connecting to Cisco AnyConnect VPN
# Copyright (C) 2020 Caleb Sargeant (scripts@calebsargeant.com)
# Permission to copy and modify is granted under this license: https://github.com/CalebSargeant/scripts/blob/master/LICENSE
# Last revised 2020-03-15

# https://rakhesh.com/powershell/vpn-client-over-riding-dns-on-macos/

# MANUALLY:
# sudo scutil
# list ".*DNS"
# get State:/Network/Service/com.cisco.anyconnect/DNS
# d.show
# d.remove SearchDomains
# d.remove ServerAddresses
# d.add ServerAddresses * 10.145.64.21
# set State:/Network/Service/com.cisco.anyconnect/DNS
# exit

# $1 is the first arguement - ip address of dns server

sudo scutil << EOF
get State:/Network/Service/com.cisco.anyconnect/DNS
d.remove ServerAddress
d.add ServerAddresses * "$1"
set State:/Network/Service/com.cisco.anyconnect/DNS
exit
EOF
