#!/bin/bash
# Mass rename all files in current folder (needs work)
# Copyright (C) 2020 Caleb Sargeant (scripts@calebsargeant.com)
# Permission to copy and modify is granted under this license: https://github.com/CalebSargeant/scripts/blob/master/LICENSE
# Last revised 2019

i=1
  ls *.mkv | while read filename; do
  season=$(echo $filename | sed 's/.*S0\+\([0-9]\+\)E\([0-9]\+\).*/\1/')
  episode=$(echo $filename | sed 's/.*S0\+\([0-9]\+\)E\([0-9]\+\).*/\2/')
  new_filename=$(echo $filename | sed "s/S0\+\([0-9]\+\)E\([0-9]\+\)/S${season}E${episode}/")
  echo mv "$filename" "$new_filename"
done