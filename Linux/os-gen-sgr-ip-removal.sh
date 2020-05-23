#!/bin/bash
# Generate openstack cli to remove IP Addresses from Security Groups
# Copyright (C) 2020 Caleb Sargeant (scripts@calebsargeant.com)
# Permission to copy and modify is granted under this license: https://github.com/CalebSargeant/scripts/blob/master/LICENSE
# Last revised 2019

# Set the recorded date
rdate=`date +%Y%m%d`

# Get the user to input the IP ADDRESS
#read -p 'Enter IP Address or part thereof: ' CIDRIP

IP=$(echo $1 | sed 's:/:-:g')

# Set the FILENAME
#FILENAME=$rdate-os-$OS_PROJECT_NAME-gen-sgr-ip-removal-$IP
FILENAME=$rdate-os-gen-sgr-ip-removal-$IP

# Generate the INPUT from grepping the IP ADDRESS and doctoring in OpenStack
openstack security group rule list | grep $1 | awk '{print $6,"_"$4,"_",$8,"_",$12,"_",$2,"_",$11}' | sed 's/ //g' | sed 's/:/-/g' | sed 's:/:-:g' > /tmp/rule-target.log

# Generate the OUTPUT for each line from the INPUT
for line in $(cat /tmp/rule-target.log)
        do
                # Set the SOURCE IP/SUBNET, PROTOCOL, and PORT variables
                SUBNET=$(echo $line | awk -F "_" '{print $1}')
                PROTO=$(echo $line | awk -F "_" '{print $2}')
                PORT=$(echo $line | awk -F "_" '{print $3}')

                # Set the SECURITY GROUP ID variable - an if statement is required, as a column is blank in OUTPUT, changing AWK's column numbering
                if [ "$PROTO" = "icmp" ] || [ "$PROTO" = "None" ]
                        then
                                SGID=$(echo $line | awk -F "_" '{print $6}')
                                #echo match
                        else
                                SGID=$(echo $line | awk -F "_" '{print $4}')
                        fi

                # Set the SECURITY GROUP RULE ID variable
                SGRID=$(echo $line | awk -F "_" '{print $5}')

                # Set the SECURITY GROUP name variable from the SECURITY GROUP ID, delete 'munchcloud line'
                SG=$(openstack security group show $SGID | grep name | awk '{print $4}' | grep -v "Munch({'cloud':")

                # Generate a live log
                echo -e Found "\e[1m\e[33m$SUBNET\e[0m\e[0m" - "\e[1m\e[36m$PROTO\e[0m\e[0m" - "\e[1m\e[35m$PORT\e[0m\e[0m" in "\e[1m\e[34m$SG\e[0m\e[0m"

                # Generate manual confirmation information
                echo "##############################" >> $FILENAME.sh
                echo "###" Subnet: $SUBNET >> $FILENAME.sh
                echo "###" Proto/Port: $PROTO / $PORT >> $FILENAME.sh
                echo "###" Security Group: $SG >> $FILENAME.sh
                echo "#########################################################################" >> $FILENAME.sh

                # Generate the code to execute (be careful with copying this between windows without checking manually first)
                echo openstack security group rule delete $SGRID >> $FILENAME.sh
                echo  >> $FILENAME.sh

                # Generate a raw log
                openstack security group rule show $SGRID >> $FILENAME.log
        done

# Delete the INPUT
rm /tmp/rule-target.log

# Make FILENAME executable (be careful about executing without manually checking) - commenting this out for now
#chmod u+x $FILENAME.sh
