#!/bin/bash
# Generate Ansible playbook to import zabbix hosts
# Copyright (C) 2020 Caleb Sargeant (scripts@calebsargeant.com)
# Permission to copy and modify is granted under this license: https://github.com/CalebSargeant/scripts/blob/master/LICENSE
# Last revised 2019

OUTPUT="output.yml"

# TEMPLATE ASSOCIATIVE ARRAY
declare -A device_templates=(
  [compute]="compute template name"
  [ad]="ad template name"
  [asa]="asa template name"
  [sw]="sw template name"
  [uap]="uap template name"
  [lb]="lb template name"
)

expected_state() {
  cat expected_state.csv | grep -o '^[^#]*' | sed -e '/^$/d'
}

value() {
  echo $line | awk -F "," '{print $'$@'}'
}

ansible() {
  hosts() {
    printf -- "---\n- hosts: $ZABBIX_SERVER\n\n"
  }
  vars() {
    printf "  vars:
    server_url: $ZABBIX_SERVER_URL
    login_user: $ZABBIX_USERNAME
    login_password: $ZABBIX_PASSWORD\n\n"
  }
  tasks(){
    # TO BE ADDED
    #zabbix_template() {
    #}
    #zabbix_group() {
    #}
    zabbix_host() {
      printf -- "    - name: Create/Update Host - $FQDN
      zabbix_host: $FQDN
      visible_name: $VISIBLE_NAME
      description: $DESCRIPTION
      host_groups:
        - $HOST_GROUP
      link_templates:
        - $TEMPLATE
      interfaces:
        - type: $INT_TYPE
          main: 1
          useip: $INT_USEIP
          ip: $INT_IP
          dns: $FQDN
      server_url: {{ server_url }}
      login_user: {{ login_user }}
      login_password: '{{ login_password }}'
      status: $STATUS
      state: $STATE\n\n"
      }
      "$@"
    }
    "$@"
}

# TO BE ADDED to either get_variables, or create new var funtions, or migrate to nested var functions
#visible_name
#host_groups
#type
#useip
#status

# TO BE FIXED
get_template() {
  # If hostname has a -p- in it, extract DEVICE
  if [[ $(value 2) == *"-p-"* ]]; then
    DEVICE=$(value 2 | awk -F "-" '{print $3}' | cut -d'-' -f 2)
  else
    # Loop against array until find DEVICE match
    for i in "${!device_templates[@]}"; do
      if [[ $(value 2) == *"$i"* ]]; then
        DEVICE="$i"
      fi
    done
    # Set TEMPLATE based on DEVICE
    TEMPLATE=$(echo ${device_templates[$DEVICE]})
  fi
  # A dirty "if DEVICE is nothing then TEMPLATE is nothing"
  if [[ "$DEVICE" ]]; then
    DEVICE=$DEVICE
  else
    TEMPLATE=""
  fi
}

get_variables() {
  FQDN=$(value 2)
  INT_IP=$(value 3)
  INT_TYPE=$(value 4)
#  INT_USEIP=$(get_useip)
#  TEMPLATE=$(get_template)

  # Set the STATE variable
  if [[ "$(value 1)" == "add" ]]; then
    STATE="present"
  elif [[ "$(value 1)" == "remove" ]]; then
    STATE="absent"
  else
    echo "Please use 'add' or 'remove'!" & exit 1
  fi
}

# GENERATE OUTPUT PLAYBOOK
ansible hosts > "$OUTPUT"
ansible vars >> "$OUTPUT"
echo "  tasks:" >> "$OUTPUT"
# ansible tasks zabbix_host
for line in $(expected_state); do
  get_template
  get_variables
  ansible tasks zabbix_host >> "$OUTPUT"
done
echo "..." >> "$OUTPUT"

# RUN THE OUTPUTTED PLAYBOOK
#ansible-playbook "$OUTPUT"
