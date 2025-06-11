#!/bin/bash
# converts all webp to png for each dir
# Copyright (C) 2020 Caleb Sargeant (scripts@calebsargeant.com)
# Permission to copy and modify is granted under this license: https://github.com/CalebSargeant/scripts/blob/master/LICENSE
# Last revised 2020

if [[ -z "$1" ]]; then
  echo "Usage $0 DIR"
  exit 1
fi

for d in `find $1 -type d`; do
  cd "$d"
  for i in `ls $d | grep webp | cut -f 1 -d '.'`; do
    dwebp "$i.webp" -o "$i.png"
    rm "$i.webp"
  done
done
