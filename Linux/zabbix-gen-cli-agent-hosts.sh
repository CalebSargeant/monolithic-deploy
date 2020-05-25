#!/bin/bash
# Generate Zabbix CLI lines to run to import agent-based hosts
# Copyright (C) 2020 Caleb Sargeant (scripts@calebsargeant.com)
# Permission to copy and modify is granted under this license: https://github.com/CalebSargeant/scripts/blob/master/LICENSE
# Last revised April 2020

### README -- we cannot create SNMP hosts with Zabbix CLI - the host is ALWAYS created with an agent interface BY DEFAULT
###        -- this script has been modified to only generate agent cli input
###        -- a V2 of this script must be created to generate XML input instead
###        -- in other words - no more fancy cli and api, etc - there are always small issues with these - just use raw, pure XML input
###        -- see if statement comments. Also, you cannot copy&paste output code into terminal - zabbix cli freaks out, you have to copy 10 lines at a time...

DNSSERVER="1.1.1.1"
rdate=`date +%Y%m%d`
FILENAME="$rdate-$1.log"

# FUNCTIONS
expected_state() {
  cat expected_state.csv | grep -o '^[^#]*' | sed -e '/^$/d' | sed 's/ /?/g'
}

value() {
  echo "$line" | awk -F "," '{print $'$@'}' | sed 's/?/ /g'
}

# SET THE CREDENTIALS
sudo rm ~/.zabbix-cli_auth
echo "Admin::zabix" > ~/.zabbix-cli_auth
chmod 400 ~/.zabbix-cli_auth

# SET THE ZABBIX SERVER
echo zabbix-cli-init -z http://$1/zabbix | tee "$FILENAME"

# CREATE HOST GROUP
# https://github.com/unioslo/zabbix-cli/blob/master/docs/manual.rst#create-hostgroup
#zabbix-cli -C create_hostgroup '$HOSTGROUP'

for line in $(expected_state); do
	# VARIABLES
	STATE=$(value 1)
  TYPE=$(value 2)
  HOSTGROUP=$(value 3)
  HOSTNAME=$(value 4)
  IPADDRESS=$(value 5)
	#IPADDRESS=$(dig @$DNSSERVER +short $HOSTNAME)

  if [[ "$TYPE" == "agent" ]]; then
    INT_TYPE="1"
    PORT="10050"
    # we are only creating the host if it is an agent type
    echo "zabbix-cli -C \"create_host '$HOSTNAME' '$HOSTGROUP' '' '0'\"" | tee -a $FILENAME
    echo "zabbix-cli -C \"add_host_to_hostgroup '$HOSTNAME' '$HOSTGROUP'\"" | tee -a "$FILENAME"

  elif [[ "$TYPE" == "snmp" ]]; then
    INT_TYPE="2"
    PORT="161"
    # we continue to the next line if we have a host with SNMP
    continue
  fi

	# CREATE HOST
	# https://github.com/unioslo/zabbix-cli/blob/master/docs/manual.rst#create-host
	#echo "zabbix-cli -C \"create_host '$HOSTNAME' '$HOSTGROUP' '' '0'\"" | tee -a $FILENAME

	# CREATE HOST INTERFACE
	# https://github.com/unioslo/zabbix-cli/blob/master/docs/manual.rst#create-host-interface
	#echo "zabbix-cli -C \"create_host_interface '$HOSTNAME' '0' '$INT_TYPE' '$PORT' '$IPADDRESS' '$HOSTNAME' '1'\"" | tee -a "$FILENAME"

	# ADD HOST TO HOST GROUP
	# https://github.com/unioslo/zabbix-cli/blob/master/docs/manual.rst#add-host-to-hostgroup
	#echo "zabbix-cli -C \"add_host_to_hostgroup '$HOSTNAME' '$HOSTGROUP'\"" | tee -a "$FILENAME"
done
