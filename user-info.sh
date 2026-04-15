#!/bin/bash

USER=nikita
HOSTNAME=$(hostname)
ID_USER=$(cat /etc/passwd | grep nikita | cut -d':' -f3)
SHELL_USER=$(cat /etc/passwd | grep nikita | rev | cut -d':' -f1 | rev)

if id $USER &> /dev/null; then
	echo "user $USER exist on $HOSTNAME with ID $ID_USER and command shell $SHELL_USER"
else
	echo "user $USER not exist"
fi
