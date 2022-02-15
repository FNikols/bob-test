#!/bin/bash
# Запускать из /client.web/ командой sh ../dev.conf/ci/run_local.sh   !!! надо контролировать !!!

# ================================
# Проверка наличия входных параметров
# ================================
#if [ -n "$1" ]; then
#    CMD=$1
#else
#    echo "Команда не указана"
#fi

# ================================
# СЕРВЕРА
# ================================
SRV="/var/srv/srv10"
NO_SRV="10"
#DEV_SRV="10.1.100.104"
#dev_redis="10.1.100.105"

# cd ../..
#DIR=$(pwd)
#echo "$DIR"
DIR="/var/srv/build"
cd "$DIR" || exit

rsync -a "$DIR""/client.web/"* "$SRV""/client.web/"

echo "=================================="
echo "   Перезапуск процесса"
echo "=================================="
# cd ../client.web
cd "$SRV"/client.web || exit
#npm run start - так работает хорошо
#npm run build
#pm2 restart clieqntweb"$NO_SRV"
#pm2 kill
#pm2 start clientweb"$NO_SRV"  ---так что-то не хочет
#pm2 start /var/srv/srv"$NO_SRV"/client.web/build/index.js --name clientweb"$NO_SRV" # НЕ работает, версия = 1.0.0
#pm2 start /var/srv/srv"$NO_SRV"/client.web/build/App.js --name clientweb"$NO_SRV" # НЕ работает, версия = 1.0.0
pm2 start ./node_modules/nuxt/bin/nuxt.js --name clientweb"$NO_SRV" -- start # работает, версия = 2.15.8
echo "Код возврата = "$?
