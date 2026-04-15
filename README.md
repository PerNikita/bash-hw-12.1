#HW-12.1

### 1) Написать скрипт, который будет собирать информацию о системе (количество ядер cpu, версия ОС, серый ip) и выводить ее в табличном виде
```
#!/bin/bash

CPU=$(nproc)
OS=$(lsb_release -a | cut -d':' -f 2 | head -n1)
IP=$(ip -4 -o a | grep "enp0s3" | awk -F' '  '{print $4}' | cut -d'/' -f1)

printf '%-15s %-10s %-10s\n' "cpu" "os" "ipv4"
printf '%-10s %-10s %-10s\n' "$CPU" "$OS" "$IP"
```
<img width="505" height="79" alt="изображение" src="https://github.com/user-attachments/assets/75af7859-1da3-4e33-bec8-c64983571d9a" />

### 2) Написать скрипт, который будет получать сколько процентов диска использовано и делать запись в файл `/var/log/disk_space.log`, если это число превысило LIMIT; Значение LIMIT выбрать самостоятельно

```
#!/bin/bash

DISK_USAGE=$(df -Th | grep ext4 | head -n1 | awk '{print $6}')
LIMIT=55

if [ $DISK_USAGE > $LIMIT ]; then
	$(echo -e "Дискового пространство использовано: ${DISK_USAGE}\nВыбранный лимит: ${LIMIT}%" >> disk-usage.log)
	echo "Лимит превышен на $((${DISK_USAGE//%/} - $LIMIT))%" >> disk-usage.log
fi
```

<img width="596" height="75" alt="изображение" src="https://github.com/user-attachments/assets/8b30796b-3e55-4f59-a33d-b666b5613a19" />

### 3) Написать скрипт для поиска свободных портов из диапазона `80-8000`; скрипт должен иметь возможность искать как на локальной машине так и на удаленно 

```
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
```

<img width="688" height="97" alt="изображение" src="https://github.com/user-attachments/assets/f18bef41-6dc0-453b-9e8e-86f2bb81a8ee" />

### 4) Написать скрипт, который будет выводить количество процессов указанной в аргументе службы. Например ```bash ./count.sh nginx nginx 3 ```
```
#!/bin/bash

set -o pipefail

NAME_SERVICE=$1

if [ -n $NAME_SERVICE ]; then
	PROCESS=$(pgrep $NAME_SERVICE | wc -l)
fi

echo $PROCESS
```

<img width="691" height="67" alt="изображение" src="https://github.com/user-attachments/assets/202d1b58-cc49-489f-bd4c-05bda2ecdb8b" />

### 5) Написать скрипт, который - создаст в системе двух пользователей: `site-admin` и `site-dev` - создаст в `/opt` структуру проекта ``` bookstore ├── bin ├── docs ├── lib ├── src │   ├── controllers │   ├── models │   └── views └── tests ├── integration └── unit ``` - назначит владельцем всей директории `bookstore` пользователя `site-admin`, а группой - `site-dev` - если создание пользователей и директорий было успешным - скрипт должен сделать запись в `/var/log/bookstore/creation.log` запись вида `project bookstore created at 2026-04-07-08`

```
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

```
<img width="643" height="71" alt="изображение" src="https://github.com/user-attachments/assets/f65ae4bf-2378-433c-b506-a9ad33c2bba5" />

### 6) Написать скрипт, который будет принимать на вход имя пользователя и проверять, существует ли такой в системе. Если существует, то скрипт должен вывести строку вида ``` user anestesia exist on swarm-master with ID 1000 and command shell /bin/zsh ``` если пользователя нет ``` user anestesia not exist ``` 

```
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
```

<img width="692" height="72" alt="изображение" src="https://github.com/user-attachments/assets/f093f08e-07ee-44b1-9b27-a8217052208a" />
