#!/bin/bash

CPU=$(nproc)
OS=$(lsb_release -a | cut -d':' -f 2 | head -n1)
IP=$(ip -4 -o a | grep "enp0s3" | awk -F' '  '{print $4}' | cut -d'/' -f1)

printf '%-15s %-10s %-10s\n' "cpu" "os" "ipv4"
printf '%-10s %-10s %-10s\n' "$CPU" "$OS" "$IP"
