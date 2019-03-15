# Настройка на Windows

1. Загружаем .p12 архив на клиент
2. Сертификат и приватный ключ должен быть установлен в хранилище Локальной машины или быть представленным на токене
3. Выбираем тип соединения (Протестировано на IKEv2-MSCHAPv2, IKEv2-Cert, IKEv2-PEAP-MSCHAPv2)



# Особенности работы на Windows

### - Не применяются TS-предложения маршрутов
https://lists.strongswan.org/pipermail/users/2018-January/012061.html
https://wiki.strongswan.org/projects/strongswan/wiki/WindowsClients#Split-routing-on-Windows-10-and-Windows-10-Mobile

Решение: вручную создавать маршруты для пропуска трафика


### - Все настроил, но "IKE credentials are unacceptable"

делаем все по инструкции, а именно добавляем параметр в реестр - https://serverfault.com/questions/536092/strongswan-ikev2-windows-7-agile-vpn-what-is-causing-error-13801
