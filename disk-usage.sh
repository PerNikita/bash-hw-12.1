#!/bin/bash

DISK_USAGE=$(df -Th | grep ext4 | head -n1 | awk '{print $6}')
LIMIT=55

if [ $DISK_USAGE > $LIMIT ]; then
	$(echo -e "Дискового пространство использовано: ${DISK_USAGE}\nВыбранный лимит: ${LIMIT}%" >> disk-usage.log)
	echo "Лимит превышен на $((${DISK_USAGE//%/} - $LIMIT))%" >> disk-usage.log
fi
