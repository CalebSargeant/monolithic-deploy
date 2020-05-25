#!/bin/bash
# install zabbix cli
# Copyright (C) 2020 Caleb Sargeant (scripts@calebsargeant.com)
# Permission to copy and modify is granted under this license: https://github.com/CalebSargeant/scripts/blob/master/LICENSE
# Last revised 2018

# Get hold of the source code
git clone https://github.com/usit-gd/zabbix-cli.git

# Install from source (recommended method)
cd zabbix-cli/
sudo ./setup.py install

# Generate config - can be replaced with http://zabbix_server_hostname/zabbix
zabbix-cli-init -z http://null
