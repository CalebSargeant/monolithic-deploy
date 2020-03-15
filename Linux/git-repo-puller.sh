#!/bin/bash
# Automatically pull repos (needs work)
# Copyright (C) 2020 Caleb Sargeant (scripts@calebsargeant.com)
# Permission to copy and modify is granted under this license: https://github.com/CalebSargeant/scripts/blob/master/LICENSE
# Last revised 2018

repos=~/repos

cd $repos/$1
git pull

cd $repos/$2
git pull

cd $repos/$3
git pull
