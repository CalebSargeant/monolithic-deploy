#!/bin/bash
# converts all md to rst for each dir
# Copyright (C) 2020 Caleb Sargeant (scripts@calebsargeant.com)
# Permission to copy and modify is granted under this license: https://github.com/CalebSargeant/scripts/blob/master/LICENSE
# Last revised 2020

if [[ -z "$1" ]]; then
  echo "Usage $0 DIR"
  exit 1
fi

for d in `find $1 -type d`; do
  cd "$d"
  #for i in `ls $d | grep .md | cut -f 1 -d '.'`; do
  for i in `ls $d | grep .md | sed 's|\(.*\)....*|\1|'`; do

    #dwebp "$i.webp" -o "$i.png"
    pandoc "$i.md" -t rst -o "$i.rst"
    #rm "$i.webp"
  done
done
