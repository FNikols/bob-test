#!/bin/bash
# ================================
# СЕРВЕРА
# ===============================
NO_SRV="12"
SRV="/var/srv/srv""$NO_SRV"
DIR="/var/srv/build"
cd "$SRV" || exit
git init

echo "=========================================="
echo " Инициализируем сервер ""$SRV"
echo "=========================================="

echo "=========================================="
echo " Создать каталог и получить dev.conf "
echo "=========================================="
#mkdir dev.conf && cd "$SRV"/dev.conf || exit
git clone git@git.63pokupki.ru:sp/dev.conf.git
#cd ..

echo "======================================="
echo "Создать каталог и получить client.web"
echo "======================================="
# mkdir client.web && cd "$SRV"/client.web || exit
git clone git@git.63pokupki.ru:sp/client.web.git
cp $DIR/client.web/src/configs/config*.private.sample.ts $DIR/client.web/src/configs/config.private.ts
cp $DIR/client.web/src/configs/config*.public.sample.ts $DIR/client.web/src/configs/config.public.ts
# cd ..
