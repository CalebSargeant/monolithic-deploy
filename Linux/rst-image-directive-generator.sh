#!/bin/bash
# Script to generate RST image directives
# Copyright (C) 2020 Caleb Sargeant (scripts@calebsargeant.com)
# Permission to copy and modify is granted under this license: https://github.com/CalebSargeant/scripts/blob/master/LICENSE
# Last revised 2020-03-15

# 1 = source
# 2 = part of name of files

directive=".. image:: _images"

var=$(
  for i in $(ls "$1" | grep "$2"); do
    echo "$i"
  done | sort -V
  )

for l in $(echo "$var"); do
  echo "$directive/$l"
  echo ""
done
