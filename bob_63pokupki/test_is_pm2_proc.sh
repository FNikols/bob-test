#!/bin/sh
cd /srv/srv10/client.web/ || exit

pm2 list | grep clientweb10 &>/dev/null # Подавление вывода.
ret=$?
echo "=================================="
echo " RET = "$ret
echo "=================================="

if [ $ret -eq 1 ]; then
    {
	echo "=================================="
	echo "       Запуск ClientWeb10"
	echo "=================================="
	pm2 start -f ./node_modules/nuxt/bin/nuxt.js --name clientweb10 -- start
	echo "Код возврата старта = "$?
    }
else
    {
	echo "=================================="
	echo "       Рестарт ClientWeb10"
	echo "=================================="
	pm2 restart ./node_modules/nuxt/bin/nuxt.js --name clientweb10 -- restart
	echo "Код возврата рестарта = "$?
    }
fi

pm2 list | grep clientweb
