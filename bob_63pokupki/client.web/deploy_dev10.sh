#!/bin/bash
# Запускать из /client.web/ командой sh ../dev.conf/ci/run_local.sh   !!! надо контролировать !!!

# ================================
# СЕРВЕРА
# ===============================
NO_SRV="10"
SRV="/var/srv/srv""$NO_SRV"
DIR="/var/srv/build"
cd "$DIR" || exit

# shellcheck source=/dev/null
. ./dev.conf/ci/config.sh

echo ==================================
echo Обновить код на 10 контуре
echo ==================================

rm -fr $SRV/client.web/*
cd $DIR/client.web/ || exit
rsync -a "$DIR""/client.web/"* "$SRV""/client.web/"

echo ==================================
echo Запуск Client.Web
echo ==================================
cd "$DIR"/client.web || exit
pm2 start ./node_modules/nuxt/bin/nuxt.js --name clientweb"$NO_SRV" -- start # работает, версия = 2.15.8
echo "Код возврата = "$?
