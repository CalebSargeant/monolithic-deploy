#!/bin/bash
# Script to move and rename images
# Copyright (C) 2020 Caleb Sargeant (scripts@calebsargeant.com)
# Permission to copy and modify is granted under this license: https://github.com/CalebSargeant/scripts/blob/master/LICENSE
# Last revised 2020-03-15


# 1 = source
# 2 = dest
# 3 = filename

cd "$1"

i=1
for IMG in *.png; do
        mv "$IMG" "${IMG// /_}"
        mv "$IMG" "$2/$3-$i.png"
        i=$((i+1));
done
