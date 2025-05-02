# Настройка Debian

* Рекомендую [статью](https://serveradmin.ru/nastroyka-seti-v-debian/) к прочтению, наткнулся на неё уже после написания своего гайда. В ней описаны более верные подходы к настройкам.*

Если VirtualBox, перед установкой дополнений:

```bash
sudo apt install build-essential dkms linux-headers-$(uname -r) -y
```

# Перед всем

**⚠️ Если команды в списках содержат su или micro, то из нужно выполнять последовательно, а не все команды сразу. ⚠️**

## Создать 2 отдельных подключения

1. Интернет с прокси NAT
2. Без прокси - LAN Segment для локальной сети адреса, шлюз - от debian, устройство поставить **ens33**, либо менять везде на свой после просмотра с помощью:

```bash
ip -c a
```

Изменение адаптеров:

```bash
nmtui
```

## Дать пользователю все права

```bash
su root  
nano /etc/sudoers 
```

Найти:

```ini
root	ALL=(ALL:ALL) ALL
```

И после него добавить:

```ini
max	ALL=(ALL:ALL) ALL
```

## Установить необходимые пакеты

```bash
sudo apt update 
sudo apt install net-tools micro isc-dhcp-server mousepad chromium bind9 vsftpd ftp nfs-kernel-server nginx php-fpm nfs-common dnsutils -y 
```

# Настройка NGINX+PHP

Выполнить команды:

```bash
sudo /etc/init.d/nginx start
cd /etc/nginx/sites-available/
sudo cp default mysite.com
sudo mkdir -p /var/www/mysite.com/html 
sudo chown -R www-data:www-data /var/www/mysite.com 
su
echo "<?php phpinfo(); ?>" > /var/www/mysite.com/html/index.php
sudo micro /etc/nginx/sites-available/mysite.com 
```

Содержимое файла заменить на:

```json
server { 
        listen 80 default_server; 
        listen [::]:80 default_server; 
 
        root /var/www/mysite.com/html; 
        index index.html index.php index.htm index.nginx-debian.html; 
 
        server_name mysite.com; 
 
        location / { 
                try_files $uri $uri/ =404; 
        } 
 
        location ~ \.php$ { 
                include snippets/fastcgi-php.conf; 
                fastcgi_pass unix:/var/run/php/php8.2-fpm.sock; 
        } 
}
```

В терминале выполнить:

```bash
sudo ln -s /etc/nginx/sites-available/mysite.com /etc/nginx/sites-enabled/
sudo unlink /etc/nginx/sites-enabled/default
sudo nginx -t
sudo /etc/init.d/nginx reload
echo 127.0.0.1 mysite.com www.mysite.com | sudo tee -a /etc/hosts
```

Перезапустить сервисы:

```bash
sudo systemctl restart nginx 
sudo systemctl restart php8.2-fpm 
```

В Windows нужно в файл `C:\Windows\System32\drivers\etc\hosts` добавить

```ini
13.13.13.1 mysite.com www.mysite.com 
```

# Настройка FTP

Выполнить команды:

```bash
sudo systemctl enable --now vsftpd
echo ftpuser | sudo tee -a /etc/vsftpd.userlist
sudo mkdir -p /etc/vsftpd/
echo ftpuser | sudo tee -a /etc/vsftpd/user_list
echo ftpuser | sudo tee -a /etc/vsftpd/chroot_list
sudo cp /etc/vsftpd.conf /etc/vsftpd.conf.orig
```

После этого открыть файл настроек FTP:

```bash
sudo micro /etc/vsftpd.conf 
```

Заменить содержимое на:

```ini
listen=yes
pam_service_name=vsftpd
anonymous_enable=NO
local_enable=YES
write_enable=YES
use_localtime=YES
xferlog_enable=no
connect_from_port_20=YES
chroot_local_user=YES
chroot_list_enable=YES
chroot_list_file=/etc/vsftpd/chroot_list
allow_writeable_chroot=YES
check_shell=no
user_config_dir=/etc/vsftpd/users
userlist_enable=YES
userlist_file=/etc/vsftpd/user_list
userlist_deny=NO
local_umask=022
pasv_min_port=20000
pasv_max_port=30000
```

Перезапуск службы:

```bash
sudo systemctl restart vsftpd
```

Настройка Firewall:

```bash
sudo apt install ufw -y
sudo ufw allow OpenSSH
sudo ufw allow 20:21/tcp
sudo ufw allow 80:8080/tcp
sudo ufw allow 20000:25000/tcp
sudo ufw allow 53/udp
sudo ufw allow 53/tcp
sudo ufw allow 67/udp
sudo ufw allow 111/tcp
sudo ufw allow 111/udp
sudo ufw allow 2049/tcp
sudo ufw allow 2049/udp
sudo ufw allow 4045/tcp
sudo ufw allow 4045/udp
sudo ufw allow 4046/tcp
sudo ufw allow 4046/udp
sudo ufw allow 20048/tcp
sudo ufw allow 111/tcp
sudo ufw allow 111/udp
sudo ufw allow 2049/tcp
sudo ufw allow 2049/udp
sudo ufw allow 88/tcp
sudo ufw allow 88/udp
sudo ufw allow 749/tcp
sudo ufw allow 749/udp
sudo ufw reload
sudo ufw enable
sudo ufw reload
sudo apt remove ufw
```

Далее выполнить:

```bash
su
echo -e '#!/bin/sh\necho "Shell for FTP users only."' | sudo tee -a  /bin/ftponly
sudo chmod a+x /bin/ftponly
sudo echo "/bin/ftponly" >> /etc/shells
sudo useradd -m -s /bin/ftponly ftpuser
sudo passwd ftpuser
sudo -u ftpuser mkdir -p /home/ftpuser/chroot
sudo chown -R ftpuser: /home/ftpuser/chroot
sudo -u ftpuser mkdir -p /home/ftpuser/chroot/{data,upload}
sudo chown -R ftpuser: /home/ftpuser/chroot/{data,upload}
sudo chmod 550 /home/ftpuser/chroot
sudo chmod 750 /home/ftpuser/chroot/{data,upload}
echo "ftpuser" >> /etc/vsftpd.userlist
sudo systemctl restart vsftpd
```

# Настройка NFS

Выполнить команды:

```bash
sudo mkdir -p /mnt/nfs/
sudo chmod 777 /mnt/nfs/
echo "/mnt/nfs/    13.13.13.2(rw,sync,no_root_squash,no_subtree_check)" | sudo tee -a /etc/exports
```

Проверить корректность настройки и применить настройки. Создание тестового файла.

```bash
sudo exportfs -r
sudo exportfs
sudo touch /mnt/nfs/general.test
```

На Windows:

Разрешить сетевое обнаружение (через сеть настроить) и выполнить в PowerShell:

```powershell
Enable-WindowsOptionalFeature -FeatureName ServicesForNFS-ClientOnly, ClientForNFS-Infrastructure -Online -NoRestart 
```

Проверка в проводнике: `\\13.13.13.1\mnt\nfs`

# Настройка DNS ([понятно показано](https://ispserver.ru/help/server-imyon-dns-na-os-linux-bez-paneli-ispmanager))

Выполнить команды:

```bash
su
systemctl start bind9
micro /etc/bind/named.conf.options
```

Содержимое заменить на:

```json
options {
	listen-on { any; };
	directory "/var/cache/bind";
	// forwarders {
	// 	0.0.0.0;
	// };
	allow-query { any; };
	recursion yes;
	listen-on-v6 { any; };
};
```

Далее выполнить команду:

```bash
micro /etc/bind/named.conf.local
```

Содержимое заменить на:

```json
//
// Do any local configuration here
//

// Consider adding the 1918 zones here, if they are not used in your
// organization
//include "/etc/bind/zones.rfc1918";

zone "maxio.com" {
    type master;
    file "master/maxio.com";
    allow-transfer { none; };
    allow-update { none; };
};
```

Выполнить команды:

```
mkdir -p /var/cache/bind/master
sudo micro /var/cache/bind/master/maxio.com
```

Вставить текст:

```ini
$TTL 14400

maxio.com.    IN      SOA     ns1.maxio.com. admin.maxio.com. (
        2019121812      ;Serial
        3600            ;Refresh
        3600            ;Retry
        604800          ;Expire
        86400           ;Negative Cache TTL
)

        IN      NS      ns1.maxio.com.
        IN      NS      ns2.maxio.com.
        IN      MX      10       mail

@       IN      A       13.13.13.1
ns1     IN      A       13.13.13.1
ns2     IN      A      	13.13.13.1
www     IN      A      	13.13.13.1
mail    IN      A       13.13.13.1
```

Применить настройки:

```bash
systemctl restart named && systemctl restart bind9
```

В Windows в адаптере указать DNS: **13.13.13.1**

Проверка DNS:

```shell
nslookup
> set type=ns
> maxio.com
```

Должны отображаться: maxio.com, ns1.maxio.com, ns2.maxio.com, 13.13.13.1

# Настройка DHCP

Выполнить команду:

```bash
sudo micro /etc/default/isc-dhcp-server
```

Содержимое заменить на:

```ini
# Defaults for isc-dhcp-server (sourced by /etc/init.d/isc-dhcp-server)
# Path to dhcpd's config file (default: /etc/dhcp/dhcpd.conf).
DHCPDv4_CONF=/etc/dhcp/dhcpd.conf
#DHCPDv6_CONF=/etc/dhcp/dhcpd6.conf
# Path to dhcpd's PID file (default: /var/run/dhcpd.pid).
DHCPDv4_PID=/var/run/dhcpd.pid
#DHCPDv6_PID=/var/run/dhcpd6.pid
# Additional options to start dhcpd with.
#       Don't use options -cf or -pf here; use DHCPD_CONF/ DHCPD_PID instead
#OPTIONS=""
# On what interfaces should the DHCP server (dhcpd) serve DHCP requests?
#       Separate multiple interfaces with spaces, e.g. "eth0 eth1".
INTERFACESv4="ens33"
#INTERFACESv6=""
```

Далее выполнить:

```bash
sudo micro /etc/dhcp/dhcpd.conf
```

Содержимое заменить на:

```ini
# dhcpd.conf
#
# Sample configuration file for ISC dhcpd
#

# option definitions common to all supported networks...
option domain-name "maxio.com";
option domain-name-servers 13.13.13.1;

default-lease-time 600;
max-lease-time 7200;

# The ddns-updates-style parameter controls whether or not the server will
# attempt to do a DNS update when a lease is confirmed. We default to the
# behavior of the version 2 packages ('none', since DHCP v2 didn't
# have support for DDNS.)
ddns-update-style none;

# If this DHCP server is the official DHCP server for the local
# network, the authoritative directive should be uncommented.
#authoritative;

# Use this to send dhcp log messages to a different log file (you also
# have to hack syslog.conf to complete the redirection).
#log-facility local7;

# No service will be given on this subnet, but declaring it helps the 
# DHCP server to understand the network topology.

#subnet 10.152.187.0 netmask 255.255.255.0 {
#}

# This is a very basic subnet declaration.

subnet 13.13.13.0 netmask 255.255.255.0 {
  range 13.13.13.2 13.13.13.42;
#  option routers rtr-239-0-1.example.org, rtr-239-0-2.example.org;
}

# This declaration allows BOOTP clients to get dynamic addresses,
# which we don't really recommend.

#subnet 10.254.239.32 netmask 255.255.255.224 {
#  range dynamic-bootp 10.254.239.40 10.254.239.60;
#  option broadcast-address 10.254.239.31;
#  option routers rtr-239-32-1.example.org;
#}

# A slightly different configuration for an internal subnet.
#subnet 10.5.5.0 netmask 255.255.255.224 {
#  range 10.5.5.26 10.5.5.30;
#  option domain-name-servers ns1.internal.example.org;
#  option domain-name "internal.example.org";
#  option routers 10.5.5.1;
#  option broadcast-address 10.5.5.31;
#  default-lease-time 600;
#  max-lease-time 7200;
#}

# Hosts which require special configuration options can be listed in
# host statements.   If no address is specified, the address will be
# allocated dynamically (if possible), but the host-specific information
# will still come from the host declaration.

#host passacaglia {
#  hardware ethernet 0:0:c0:5d:bd:95;
#  filename "vmunix.passacaglia";
#  server-name "toccata.example.com";
#}

# Fixed IP addresses can also be specified for hosts.   These addresses
# should not also be listed as being available for dynamic assignment.
# Hosts for which fixed IP addresses have been specified can boot using
# BOOTP or DHCP.   Hosts for which no fixed address is specified can only
# be booted with DHCP, unless there is an address range on the subnet
# to which a BOOTP client is connected which has the dynamic-bootp flag
# set.
#host fantasia {
#  hardware ethernet 08:00:07:26:c0:a5;
#  fixed-address fantasia.example.com;
#}

# You can declare a class of clients and then do address allocation
# based on that.   The example below shows a case where all clients
# in a certain class get addresses on the 10.17.224/24 subnet, and all
# other clients get addresses on the 10.0.29/24 subnet.

#class "foo" {
#  match if substring (option vendor-class-identifier, 0, 4) = "SUNW";
#}

#shared-network 224-29 {
#  subnet 10.17.224.0 netmask 255.255.255.0 {
#    option routers rtr-224.example.org;
#  }
#  subnet 10.0.29.0 netmask 255.255.255.0 {
#    option routers rtr-29.example.org;
#  }
#  pool {
#    allow members of "foo";
#    range 10.17.224.10 10.17.224.250;
#  }
#  pool {
#    deny members of "foo";
#    range 10.0.29.10 10.0.29.230;
#  }
#}
```

Далее зайти в интерфейсы:

```bash
sudo micro /etc/network/interfaces
```

Найти настройки для адаптера:

```ini
# This file describes the network interfaces available on your system
# and how to activate them. For more information, see interfaces(5).

source /etc/network/interfaces.d/*

# The loopback network interface
auto lo
iface lo inet loopback

# The primary network interface
allow-hotplug ens33
iface ens33 inet static
address 13.13.13.1
network 255.255.255.0
```

Перезапустить службу:

```bash
sudo systemctl restart isc-dhcp-server
```

Подключить Windows по DHCP.

Проверить что Windows точно была добавлена:

```bash
cat /var/lib/dhcp/dhcpd.leases
```
