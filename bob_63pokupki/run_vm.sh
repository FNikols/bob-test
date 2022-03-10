#!/bin/bash
cd ..
DIR=$(pwd)

# DIR="/var/srv/srv10"
echo "$DIR"

# ================================
# СЕРВЕРА
# ================================
DEV_SRV="10.1.100.104"
#dev_redis="10.1.100.105"

# ================================
# Проверка наличия входных параметров
# ================================
if [ -n "$1" ]; then
    CMD=$1
else
    echo "Команда не указана"
fi

#ssh -o StrictHostKeygit checkout defChecking=no root@DEV_SRV
#su - safeuser -c
echo "=================================="
echo "              Step 1"
echo "=================================="
if ! [ -d "$DIR""/client.web/" ]; then
    echo "Не могу перейти в каталог ""$DIR""/client.web/"
    exit 1
fi
cd "$DIR""/client.web/" || exit

if git checkout dev; then
    if git stash -u; then
        if git pull; then
            if git checkout dev; then
                git pull
            fi
        else
            exit 1
        fi
    else
        exit 1
    fi
else
    exit 1
fi

echo "=================================="
echo "              Step 2"
echo "=================================="
#cd /srv/dev.conf/ && git checkout master && git stash && git pull
if ! [ -d "$DIR""/dev.conf" ]; then
    echo "Не могу перейти в каталог ""$DIR""/dev.conf"
    exit 1
fi
cd "$DIR""/dev.conf" || exit
if git checkout master; then
    if git stash; then
        git pull
    fi
fi

echo "========================================"
echo " Step 3 копирование конфигураций public"
echo "========================================"
cp -pr "$DIR""/dev.conf/config/devsrv/dev10config.public.ts" "$DIR""/client.web/src/configs/config.public.ts"
echo "Код возврата копирования конфигурации public = "$?

echo "========================================="
echo " Step 4 копирование конфигураций private"
echo "========================================="
cp -pr "$DIR""/dev.conf/config/devsrv/dev10config.private.ts" "$DIR""/client.web/src/configs/config.private.ts"
echo "Код возврата копирования конфигурации private = "$?

echo "=================================="
echo "  Step 5 удаление каталога build"
echo "=================================="
rm -rf /var/www/client.web/build/

echo "========================================"
echo " Step 6  удаление каталога node_modules"
echo "========================================"
rm -rf /var/www/client.web/node_modules/

echo "============================================"
echo " Step 7 - установка проекта с чистого листа"
echo "============================================"
#cd /var/www/client.web/ && npm ci
if ! [ -d "$DIR""/client.web/" ]; then
    echo "Не могу перейти в каталог ""$DIR""/client.web/"
    exit 1
fi
cd "$DIR""/client.web/" || exit
npm ci

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

echo "=================================="
echo "   Step 9 перезапуск процесса"
echo "=================================="
echo "===============>>>>>>>>>>>>>>"
# cd ../client.web
pwd
echo "CMD= ""$CMD"
echo "DIR= ""$DIR"
echo "DEV_SRV= "$DEV_SRV

# npm run start - так работает хорошо
npm run build
# pm2 restart clientweb10
# pm2 kill
# pm2 start clientweb10  ---так что-то не хочет
# pm2 start /var/srv/srv10/client.web/build/index.js --name clientweb10 # НЕ работает, версия = 1.0.0
# pm2 start /var/srv/srv10/client.web/build/App.js --name clientweb10 # НЕ работает, версия = 1.0.0
pm2 start ./node_modules/nuxt/bin/nuxt.js --name clientweb10 -- start # работает, версия = 2.15.8
echo "Код возврата = "$?
