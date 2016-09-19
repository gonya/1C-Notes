# 1C-Notes
## Установка сервера 1С Предприятия

### Установка Samba Windows shares
```
apt-get install mc htop
mkdir /home/smb && chown -R nobody:nogroup /home/smb && chmod -R 777 /home/smb && echo [smb] >> /etc/samba/smb.conf && echo comment = smb >> /etc/samba/smb.conf && echo  path = /home/smb >> /etc/samba/smb.conf && echo     guest ok = yes >> /etc/samba/smb.conf && echo     read only = no >> /etc/samba/smb.conf  && /etc/init.d/smbd restart
```

### Необходимые компоненты
   apt-get install  libssl0.9.8 libossp-uuid16 libxslt1.1 libicu52 libt1-5 t1utils imagemagick unixodbc texlive-base libgfs-1.3-2 ttf-mscorefonts-installer
   apt-get install apache2

### Установка
```
cd /home/smb/1c/1c-8.3.8.1747/linux64/
tar -xvf deb64*.gz
ls 1c-enterprise83-common_8.3.*.deb

dpkg -i 1c-enterprise83-common_8.3.*.deb
dpkg -i 1c-enterprise83-ws_8.3.*.deb
dpkg -i 1c-enterprise83-ws-nls_8.3.*.deb
dpkg -i 1c-enterprise83-common-nls_8.3.*.deb
dpkg -i 1c-enterprise83-server_8.3.*.deb
dpkg -i 1c-enterprise83-server-nls_8.3.*.deb
service srv1cv83 start
service srv1cv83 status
```

### Установка HASP

качаем http://www.safenet-sentinel.ru/helpdesk/download-space/#tabs-1

   dpkg --add-architecture i386
   apt-get update
   apt-get install libc6:i386

   dpkg -i aksusbd_7.40-1_i386.deb 
   /etc/init.d/aksusbd restart
   service aksusbd status
   lsusb 
### NetHasp

  mkdir /opt/1C/v8.3/x86_64/conf

``
/opt/1C/v8.3/x86_64/conf/nethasp.ini
[NH_COMMON]
NH_IPX = Disabled ; <--- Здесь запрещаем использовать протокол IPX
NH_NETBIOS = Disabled ; <--- Здесь запрещаем использовать протокол NetBIOS, лишний трафик нам ни к чему
NH_TCPIP = Enabled ; <--- Здесь разрешает использовать протокол TCP/IP
NH_SESSION = 15 ; <--- Продолжительность сессии с HASP-сервером в секундах
NH_SEND_RCV = 30 ; <--- Продолжительность попыток, в секундах, поиска HASP сервера в сети

[NH_NETBIOS]
;NH_NBNAME = 11tf1
;NH_SESSION = 30
;NH_SEND_RCV = 10

[NH_TCPIP]
NH_SERVER_ADDR = 192.168.0.41, 192.168.0.16, 192.168.0.218
;NH_SERVER_ADDR = 172.16.88.48, 172.16.2.248 ; <--- Адреса HASP-серверов
;NH_SERVER_NAME = 11tf1
;NH_TCPIP_METHOD = TCP ; Протокол используемый клиентом для работы с HASP-сервером
NH_USE_BROADCAST = Disabled ; <--- Запрещаем использование широковещательного запроса, т. к. лишний трафик нам в сети ни к чему
NH_SESSION = 15
NH_SEND_RCV = 30
```


от 1С пример -- http://its.1c.ru/db/v838doc#bookmark:adm:TI000000291
 ````
 /opt/1C/v8.3/x86_64/conf/nethasp.ini
[NH_COMMON]
NH_TCPIP=Enabled
[NH_TCPIP]
NH_SERVER_ADDR=192.168.0.12
NH_PORT_NUMBER=475
NH_TCPIP_METHOD=UDP
NH_USE_BROADCAST=Disabled
```

   chown -R usr1cv8:grp1cv8 /opt/1C/v8.3/x86_64/conf
### Настройка каталогов обмена
Каталоги обмена Samba 1С

   mkdir /home/smb/exchange && chown -R usr1cv8:grp1cv8 /home/smb/exchange
   mkdir /home/smb/export && mkdir /home/smb/export/tmp && chown -R usr1cv8:grp1cv8 /home/smb/export

Каталоги Документооборота
   chown -R usr1cv8:grp1cv8 /home/smb/1c/docf/ && chmod -R 777 /home/smb/1c/docf/


### Публикация apache24

   cd /opt/1C/v8.3/x86_64/
   ./webinst -apache24 -wsdir test -dir /var/www/doc02 -connstr "Srvr=127.0.0.1;Ref=doc02;"
   /etc/init.d/apache2 restart


default.vrd для 1С:Документооборот 2.1

```
default.vrd
<?xml version="1.0" encoding="UTF-8"?>
<point xmlns="http://v8.1c.ru/8.2/virtual-resource-system"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                base="/do21"
                ib="Srvr=127.0.0.1;Ref=do21;">
<ws pointEnableCommon="false">
    <point name="AddressSystem" alias="AddressSystem.1cws" enable="false" />
    <point name="DMMessageService" alias="dmmessage.1cws" enable="false" />
    <point name="DMService" alias="dm.1cws" enable="false" />
    <point name="DMX" alias="DMX.1cws" enable="true" />
    <point name="EnterpriseDataExchange_1_0_1_1" alias="EnterpriseDataExchange_1_0_1_1.1cws" enable="false" />
    <point name="EnterpriseDataUpload_1_0_1_1" alias="EnterpriseDataUpload_1_0_1_1.1cws" enable="false" />
    <point name="Exchange" alias="exchange.1cws" enable="false" />
    <point name="Exchange_2_0_1_6" alias="exchange_2_0_1_6.1cws" enable="false" />
    <point name="Files" alias="files.1cws" enable="false" />
    <point name="InterfaceVersion" alias="InterfaceVersion.1cws" enable="false" />
    <point name="MEDO" alias="medo.1cws" enable="false" />
    <point name="MEDO1C" alias="medo1c.1cws" enable="false" />
    <point name="MEDO2013" alias="medo2013.1cws" enable="false" />
    <point name="MobileDMVersionService" alias="mobileDMVersionService.1cws" enable="true" />
</ws>
```

## Разное
### Удаление сервера 1С

```
# Просмотр установленных пакетов
dpkg -l | grep 1c-enterprise83 
# Остановка сервиса
service srv1cv83 stop
# Удаление установленных пакетов
dpkg -r 1c-enterprise83-ws-nls
dpkg -r 1c-enterprise83-ws
dpkg -r 1c-enterprise83-server-nls
dpkg -r 1c-enterprise83-server
dpkg -r 1c-enterprise83-common-nls
dpkg -r 1c-enterprise83-common
```

### Установка шрифтов

копируем "EanBwrP36Tt Normal.Ttf" => /usr/share/fonts/TTF 644 root
   sudo fc-cache -fv

### Отладка сервера

   mkdir /opt/1C/v8.3/i386/conf/
   chown -R usr1cv8:grp1cv8 /opt/1C
   mkdir /var/log/1c
   chown -R usr1cv8:grp1cv8 /var/log/1c


```
/opt/1C/v8.3/i386/conf/logcfg.xml

<config xmlns="http://v8.1c.ru/v8/tech-log">;
<dump create="true" location="/var/log/1c/dumps" prntscrn="true" type="2"/>
<log history="72" location="/var/log/1c">
<event>
<eq property="name" value="EXCP"/>
</event>
<event>
<eq property="name" value="EXCPCNTX"/>
</event>
<event>
<eq property="name" value="PROC"/>
</event>
<event>
<eq property="name" value="ADMIN"/>
</event>
<event>
<eq property="name" value="MEM"/>
</event>
<event>
<eq property="name" value="LEAKS"/>
</event>
<property name="all"/>
</log>
</config>
```
      
### Технологический журнал от 1С

http://its.1c.ru/db/metod81/content/4868/1/_top/документооборот

```
/opt/1C/v8.3/i386/conf/logcfg.xml

<?xml version="1.0"?>
<config xmlns="http://v8.1c.ru/v8/tech-log">
	<dump create="true" location="C:\DUMPS" type="3" prntscrn="false"/>
	<log location="C:\LOGS_excp" history="96">
		<event>
			<eq property="Name" value="EXCP"/>
		</event>
		<property name="all"/>
	</log>
	<log location="C:\logs_long" history="28">
		<event>
			<ne property="name" value=""/>
			<ge property="duration" value="200000"/>
		</event>
		<property name="all"/>
	</log>
	<log location="C:\logs_sql" history="28">
		<event>
			<eq property="name" value="SDBL"/>
		</event>
		<property name="all"/>
	</log>
	<plansql/>
</config>
```

### Проброс USB для HASP для KVM

https://pve.proxmox.com/wiki/USB_physical_port_mapping

```
root@pve1:~# qm monitor 100
Entering Qemu Monitor for VM 100 - type 'help' for help
qm> info usbhost
  Bus 2, Addr 7, Port 1.4, Speed 1.5 Mb/s
    Class ff: USB device 0529:0001, HASP HL 3.25
  Bus 2, Addr 6, Port 1.3, Speed 1.5 Mb/s
    Class ff: USB device 0529:0001, HASP 2.17
  Bus 2, Addr 5, Port 1.2.3, Speed 1.5 Mb/s
    Class 00: USB device 09da:0260, USB Keyboard
  Bus 2, Addr 3, Port 1.1, Speed 12 Mb/s
    Class 00: USB device 09da:9090, USB Device
  Bus 1, Addr 3, Port 1.6, Speed 12 Mb/s
    Class 00: USB device 0557:2221, Hermon USB hidmouse Device
qm>

2-1.4
2-1.3

Edit the VM's configuration file nano /etc/pve/qemu-server/100.conf and add this line:
usb0: host=2-1.4
usb1: host=2-1.3
```

  * https://habrahabr.ru/post/265065/ -- Проброс USB в виртуалку по сети средствами UsbRedir и QEMU
  * http://ivnet.pro/probros-usb-ustrojstv-v-proxmox/ -- Проброс USB устройств в Proxmox
  * http://teapied.blogspot.ru/2012/10/proxmox-usb.html -- Proxmox. Проброс usb-устройств в гостевую виртуальную машину. На примере ключей 1С HASP 
### Отправка сообщений jabber из 1С

Используем скрипт notification_jabber.py -- https://github.com/vint21h/nagios-notification-jabber
   apt-get install python-xmpp
