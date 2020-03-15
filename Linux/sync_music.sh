#!/bin/bash
# Copy music from server to laptop
# Copyright (C) 2020 Caleb Sargeant (scripts@calebsargeant.com)
# Permission to copy and modify is granted under this license: https://github.com/CalebSargeant/scripts/blob/master/LICENSE
# Last revised 2018

rsync -rz -e 'ssh -p 22' --progress "root@server.example.com:/home/data/Music/Caleb/" "/Users/caleb.sargeant/Music/iTunes/iTunes Media/Music/"
