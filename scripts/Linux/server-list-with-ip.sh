#!/bin/bash
# Output a list of servers from a list, including their IP Addresses
# Copyright (C) 2020 Caleb Sargeant (scripts@calebsargeant.com)
# Permission to copy and modify is granted under this license: https://github.com/CalebSargeant/scripts/blob/master/LICENSE
# Last revised 2019

HOSTLIST=$(cat /Users/caleb.sargeant/mydnslist.txt)
DNSSERVER=dns.example.com

for H in $HOSTLIST
			do
        DIG=$(dig @$DNSSERVER $H | awk '/^;; ANSWER SECTION:$/ { getline ; print $5 }')
        COMMA=","
        OUTPUT=$H$COMMA$DIG
        echo $OUTPUT >> /Users/caleb.sargeant/outputlist.txt
      done
