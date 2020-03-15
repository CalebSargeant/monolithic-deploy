#!/bin/bash
# Mass rename all files in current folder (needs work)
# Copyright (C) 2020 Caleb Sargeant (scripts@calebsargeant.com)
# Permission to copy and modify is granted under this license: https://github.com/CalebSargeant/scripts/blob/master/LICENSE
# Last revised 2019

for L in *
			do
        mv "$L" "$1 $L"
      done
