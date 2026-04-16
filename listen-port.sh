#!/bin/bash

ALL_PORTS=$(ss -nlpt | awk '{print $4}' | cut -d':' -f2)

read -p "Введите удаленный хост или нажмите Enter для проверки локально: " HOST

if [ -n "$HOST" ]; then
	for port in {80..8000}; do
			
		if $(nc -z $HOST $port &> /dev/null); then
			echo "Port $port busy"
		else
			echo "Port $port free"
		fi

	done
else
	for port in {80..8000}; do
		for local_port in $ALL_PORTS; do
			if [[ "$port" == "$local_port" ]]; then
				echo "Local port: $port busy"
			else
				echo "Local port: $port free"
			fi
		done	
	done
fi

