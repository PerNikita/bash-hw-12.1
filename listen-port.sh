#!/bin/bash

ALL_PORTS=$(ss -nlpt | awk '{print $4}' | cut -d':' -f2)

read -p "Введите удаленный хост или нажмите Enter для проверки локально: " HOST

if [ -n "$HOST" ]; then
	for port in {80..8000}; do
		$(nc -zv $HOST $port | grep succeeded)
	done
else
	for port in {80..8000}; do
		for local_port in $ALL_PORTS; do
			if [[ "$port" == "$local_port" ]]; then
				echo $port;
			fi
		done	
	done
fi

