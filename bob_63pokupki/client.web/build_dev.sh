#!/bin/bash
# Запускать из /client.web/ командой sh ../dev.conf/ci/run_local.sh   !!! надо контролировать !!!
# ================================
# СЕРВЕРА
# ================================
NO_SRV="12"
SRV="/var/srv/srv""$NO_SRV"

echo "=========================================="
echo " Создаем сервер ""$SRV"
echo "=========================================="

#DIR=$(pwd)
#echo "$DIR"
DIR="/var/srv/build"
cd "$DIR" || exit

echo =======================================
echo "Обновляем client.web"
echo =======================================
cd $DIR/client.web || exit
git stash -u && git checkout dev && git pull

echo ==================================
echo Копируем конфиги
echo ==================================
cp -pr "$DIR""/dev.conf/config/devsrv/dev""$NO_SRV""config.public.ts" "$DIR""/client.web/src/configs/config.public.ts"
echo "Код возврата копирования конфигурации public = "$?
cp -pr "$DIR""/dev.conf/config/devsrv/dev""$NO_SRV""config.private.ts" "$DIR""/client.web/src/configs/config.private.ts"
echo "Код возврата копирования конфигурации private = "$?

echo ==================================
echo Очищаем директорию сборки
echo ==================================
rm -rf "$DIR""/client.web/node_modules/"

echo ==================================
echo Собираем проект
echo ==================================
cd "$DIR"/client.web/ && npm ci
cd "$DIR"/client.web/ && npm run build
