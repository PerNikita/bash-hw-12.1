#!/bin/bash

$(useradd -s /bin/bash -m site-admin &> /dev/null)
$(useradd -s /bin/bash -m site-dev &> /dev/null)
$(mkdir -p /opt/bookstore && cd /opt/bookstore && mkdir bin docs lib src controllers models views tests integration unit &> /dev/null)
$(chown -R site-admin:site-dev /opt/bookstore &> /dev/null)

if [ -d '/opt/bookstore' ] && id site-admin &> /dev/null && id site-dev &> /dev/null; then
	echo "Директория и пользователи существуют"
	date_folder=$(stat --format=%w /opt/bookstore | awk '{print $1}')
	echo "project bookstore created at $date_folder" > /var/log/bookstore/creation.log
else
	echo "Пользователи или директория не существуют"
fi

