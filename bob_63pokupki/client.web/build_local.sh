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

#echo ==========================================
#echo 'Клонируем проект конфигураций dev.conf'
#echo ==========================================
# mkdir dev.conf && cd $_
#git pull git@git.63pokupki.ru:sp/dev.conf.git

#echo =======================================
#echo "Получить client.web"
#echo =======================================
# mkdir client.web && cd $_
#git pull git@git.63pokupki.ru:sp/client.web.git
#cp $DIR/client.web/src/configs/config*.private.sample.ts $DIR/client.web/src/configs/config.private.ts
#cp $DIR/client.web/src/configs/config*.public.sample.ts $DIR/client.web/src/configs/config.public.ts

#echo =======================================
#echo "Обновляем client.web"
#echo =======================================
cd $DIR/client.web && git stash -u && git checkout dev && git pull && rm -rf "$DIR""/client.web/node_modules/" && npm ci

#ssh -o StrictHostKeygit checkout defChecking=no root@DEV_SRV
#su - safeuser -c
#echo "=================================="
#echo "              Step 1"
#echo "=================================="
#if ! [ -d "$DIR""/client.web/" ]; then
#    echo "Не могу перейти в каталог ""$DIR""/client.web/"
#    exit 1
#fi
#cd "$DIR""/client.web/" || exit
#git checkout dev && git stash -u && git pull && git checkout dev && git pull

echo "=================================="
echo "              Step 2"
echo "=================================="
#cd /srv/dev.conf/ && git checkout master && git stash && git pull
#if ! [ -d "$DIR""/dev.conf" ]; then
#    echo "Не могу перейти в каталог ""$DIR""/dev.conf"
#    exit 1
#fi
#cd "$DIR""/dev.conf" || exit
#git checkout master && git stash && git pull

echo "========================================"
echo " Step 3 копирование конфигураций public"
echo "========================================"
cp -pr "$DIR""/dev.conf/config/devsrv/dev""$NO_SRV""config.public.ts" "$DIR""/client.web/src/configs/config.public.ts"
echo "Код возврата копирования конфигурации public = "$?

echo "========================================="
echo " Step 4 копирование конфигураций private"
echo "========================================="
cp -pr "$DIR""/dev.conf/config/devsrv/dev""$NO_SRV""config.private.ts" "$DIR""/client.web/src/configs/config.private.ts"
echo "Код возврата копирования конфигурации private = "$?

# echo "=================================="
# echo "  Step 5 удаление каталога build"
# echo "=================================="
# rm -rf "$DIR""/client.web/build/"
# echo "Код возврата удаления каталога build = "$?

# echo "========================================"
# echo " Step 6  удаление каталога node_modules"
# echo "========================================"
# rm -rf "$DIR""/client.web/node_modules/"
# echo "Код возврата удаления каталога node_modules = "$?

# echo "============================================"
# echo " Step 7 - установка проекта с чистого листа"
# echo "============================================"
# #cd /var/www/client.web/ && npm ci
# if ! [ -d "$DIR""/client.web/" ]; then
#     echo "Не могу перейти в каталог ""$DIR""/client.web/"
#     exit 1
# fi
# cd "$DIR""/client.web/" || exit
# npm cipm2 ki

echo "========================================================"
echo " Step 8 создание приложения для создания в папку сборки"
echo "========================================================"
#cd /var/www/client.web/ && npm run build
if ! [ -d "$DIR""/client.web/" ]; then
    echo "Не могу перейти в каталог ""$DIR""/client.web/"
    exit 1
fi
cd "$DIR""/client.web/" || exit
npm run build
rsync -a "$DIR""/client.web/"* "$SRV""/client.web/"

echo "=================================="
echo "   Step 9 перезапуск процесса"
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
