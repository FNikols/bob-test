#!/bin/bash

### Вариант 2

if [ -d "/var/www/client.web/srv/" ]; then
    cd /var/www/client.web/srv/ || echo "Не могу перейти в каталог"
    exit 1
else
    echo "Нет каталога /var/www/client.web/srv/"
    exit 1
fi

echo "--->" $?
