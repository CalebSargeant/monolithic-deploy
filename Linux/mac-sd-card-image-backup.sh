#!/bin/bash
# Backup SD cards (currently only Firefly - needs work)
# Copyright (C) 2020 Caleb Sargeant (scripts@calebsargeant.com)
# Permission to copy and modify is granted under this license: https://github.com/CalebSargeant/scripts/blob/master/LICENSE
# Last revised 2018

PREFIX=`date +%C%y%m`

open "smb://$1"
sudo dd if=/dev/disk2 of=/Volumes/data/Backups/Firefly/$PREFIX-firefly.img status=progress
sudo umount /dev/disk2
date +%C%y%m%d
