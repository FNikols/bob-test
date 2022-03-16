#!/bin/sh
echo "======================================================================================="
echo "Перенос через архивирование, копирование, разворачивание на новом месте ~ 9 - 19 секунд"
echo "======================================================================================="
echo "Создаем архив проекта"
echo "=================================="
su - safeuser -c 'cd /srv/build/12/client.web && tar -cf /srv/build/build_client_web_archive.tar.gz ./*'
echo "Код возврата создания архива = "$?

# Копирование архива в новое нужное место
su - safeuser -c 'scp -p -C /srv/build/build_client_web_archive.tar.gz /srv/srv12/client.web'
echo "Код возврата копирования архива = "$?

echo "=================================="
echo "Разворачиваем архив"
echo "=================================="
su - safeuser -c 'cd /srv/srv12/client.web && tar -xf /srv/build/build_client_web_archive.tar.gz'
echo "Код возврата разворачивания архива = "$?
