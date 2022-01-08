#!/bin/bash

# go to root
cd

# update
apt-get update; apt-get -y upgrade

# install wget and curl
apt-get -y install wget curl

# install git
apt-get -y install git

# install essential package
apt-get -y install gnupg

# set time GMT +7
ln -fs /usr/share/zoneinfo/Asia/Jakarta /etc/localtime

# disable exim4
apt-get -y install sysv-rc-conf
service exim4 stop
sysv-rc-conf exim4 off

# disable apache2
service apache2 stop
systemctl disable apache2.service

# install vnstat
apt-get -y install vnstat
service vnstat restart

# edit common-password
mv vps/common-password /etc/pam.d/common-password

# install speedtest
apt-get -y install speedtest-cli

# letsencrypt
#mkdir -p /etc/letsencrypt/live
#mv vps/sg01.oneserver.xyz /etc/letsencrypt/live/sg01.hostervpn.com

# install autoreboot and autokill
echo "0 0 * * * root /usr/bin/del-exp.sh" > /etc/crontab
echo "0 0 * * * root /usr/bin/autoreboot.sh" > /etc/crontab
echo "* * * * * root /usr/bin/autokill.sh" >> /etc/crontab
echo "* * * * * root sleep 5; /usr/bin/autokill.sh" >> /etc/crontab
echo "* * * * * root sleep 10; /usr/bin/autokill.sh" >> /etc/crontab
echo "* * * * * root sleep 15; /usr/bin/autokill.sh" >> /etc/crontab
echo "* * * * * root sleep 20; /usr/bin/autokill.sh" >> /etc/crontab
echo "* * * * * root sleep 25; /usr/bin/autokill.sh" >> /etc/crontab
echo "* * * * * root sleep 30; /usr/bin/autokill.sh" >> /etc/crontab
echo "* * * * * root sleep 35; /usr/bin/autokill.sh" >> /etc/crontab
echo "* * * * * root sleep 40; /usr/bin/autokill.sh" >> /etc/crontab
echo "* * * * * root sleep 45; /usr/bin/autokill.sh" >> /etc/crontab
echo "* * * * * root sleep 50; /usr/bin/autokill.sh" >> /etc/crontab
echo "* * * * * root sleep 55; /usr/bin/autokill.sh" >> /etc/crontab
service cron restart

# install neofetch
apt-get -y install neofetch
echo "clear" >> .bash_profile
echo "neofetch" >> .bash_profile

# install nginx
apt-get -y install nginx
mv vps/nginx/default /etc/nginx/sites-available/default
mv /usr/share/nginx/html/index.html /usr/share/nginx/html/index.html.bak
mkdir /usr/share/nginx/html/ovpn
service nginx restart

# install menu
mv vps/autokill.sh /usr/bin/autokill.sh
chmod +x /usr/bin/autokill.sh
mv vps/autoreboot.sh /usr/bin/autoreboot.sh
chmod +x /usr/bin/autoreboot.sh
mv vps/bash/menu /usr/bin/menu
chmod +x /usr/bin/menu
mv vps/bash/create.sh /usr/bin/create.sh
chmod +x /usr/bin/create.sh
mv vps/bash/del-exp.sh /usr/bin/del-exp.sh
chmod +x /usr/bin/del-exp.sh
mv vps/bash/user-delete.sh /usr/bin/user-delete.sh
chmod +x /usr/bin/user-delete.sh
mv vps/bash/user-extend /usr/bin/user-extend.sh
chmod +x /usr/bin/user-extend.sh
mv vps/bash/user-login.sh /usr/bin/user-login.sh
chmod +x /usr/bin/user-login.sh
mv vps/bash/user-list.sh /usr/bin/user-list.sh
chmod +x /usr/bin/user-list.sh

# install badvpn
apt-get -y install cmake
cd vps/
tar xf badvpn-1.999.130.tar.gz
mkdir badvpn-build
cd badvpn-build/
cmake vps/badvpn-1.999.130 -DBUILD_NOTHING_BY_DEFAULT=1 -DBUILD_UDPGW=1
make install

# install rc-local
cd
mv vps/rc.local /etc/rc.local
chmod +x /etc/rc.local
mv vps/services/rc-local.service /etc/systemd/system/rc-local.service
systemctl enable rc-local.service
service rc-local restart

# install banner
mv vps/banner.html /etc/issue.net
sed -i 's@#Banner none@Banner /etc/issue.net@g' /etc/ssh/sshd_config
service ssh restart

# install dropbear
apt-get -y install dropbear
sed -i 's/NO_START=1/NO_START=0/g' /etc/default/dropbear
sed -i 's/DROPBEAR_PORT=22/DROPBEAR_PORT=82/g' /etc/default/dropbear
sed -i 's/DROPBEAR_EXTRA_ARGS=/DROPBEAR_EXTRA_ARGS="-p 448"/g' /etc/default/dropbear
sed -i 's@DROPBEAR_BANNER=""@DROPBEAR_BANNER="/etc/issue.net"@g' /etc/default/dropbear
echo "/bin/false" >> /etc/shells
service dropbear restart

# install stunnel4
apt-get -y install stunnel4
mv vps/stunnel.conf /etc/stunnel/stunnel.conf
mv vps/stunnel.pem /etc/stunnel/stunnel.pem
service stunnel4 restart

# install squid
apt-get -y install squid
mv /etc/squid/squid.conf /etc/squid/squid.conf.bak
mv vps/squid.conf /etc/squid/squid.conf
service squid restart

# install sslh
apt-get -y install sslh
mv vps/sslh /etc/default/sslh
service sslh restart

# install webmin
apt-get -y install software-properties-common apt-transport-https
wget -q http://www.webmin.com/jcameron-key.asc -O- | apt-key add -
add-apt-repository "deb [arch=amd64] http://download.webmin.com/download/repository sarge contrib"
apt update && apt-get -y install webmin
sed -i 's/ssl=1/ssl=0/g' /etc/webmin/miniserv.conf
service webmin restart

# install ddos deflate
#apt-get -y install tcpkill
#apt-get -y install grepcidr
#wget https://github.com/jgmdev/ddos-deflate/archive/master.zip
#unzip master.zip
#cd ddos-deflate-master
#./install.sh
#cd
#rm master.zip

# install shadowsocksr
cd
chmod +x vps/app/shadowsocksR.sh
cd vps/app
./shadowsocksR.sh
mkdir -p /etc/shadowsocks-r
mv /etc/shadowsocks.json /etc/shadowsocks-r/config.json
service shadowsocks restart

# install shadowsocks-libev
apt-get -y install shadowsocks-libev
mv vps/shadowsocks/config.json /etc/shadowsocks-libev/config.json
service shadowsocks-libev restart

# install cloak
cd
chmod +x vps/app/Cloak-Installer.sh
cd vps/app
./Cloak-Installer.sh
cd
cd vps/
wget https://github.com/cbeuw/Cloak/releases/download/v2.5.2/ck-server-linux-amd64-v2.5.2
mv vps/ck-server-linux-amd64-2.5.2 /usr/bin/ck-server
chmod +x /usr/bin/ck-server
mv vps/services/cloak.service /etc/systemd/system/cloak.service
systemctl enable cloak.service
service cloak restart
service cloak-server restart

# install simple-obfs
apt-get -y install --no-install-recommends build-essential autoconf libtool libssl-dev libpcre3-dev libev-dev asciidoc xmlto automake
apt-get -y upgrade
git clone https://github.com/shadowsocks/simple-obfs.git
cd simple-obfs/
git submodule update --init --recursive
./autogen.sh
./configure && make
make install

# install v2ray-plugin
cd
cd vps/
wget https://github.com/shadowsocks/v2ray-plugin/releases/download/v1.3.1/v2ray-plugin-linux-amd64-v1.3.1.tar.gz
tar -zxvf v2ray-plugin-linux-amd64-v1.3.1.tar.gz
mv vps/v2ray-plugin_linux_amd64 /usr/bin/v2ray-plugin
chmod +x /usr/bin/v2ray-plugin

# obfs-tls
cd
mv vps/shadowsocks/obfs-tls.json /etc/shadowsocks-libev/obfs-tls.json
mv vps/services/obfs-tls.service /etc/systemd/system/obfs-tls.service
systemctl enable obfs-tls.service
service obfs-tls restart

# obfs-http
mv vps/shadowsocks/obfs-http.json /etc/shadowsocks-libev/obfs-http.json
mv vps/services/obfs-http.service /etc/systemd/system/obfs-http.service
systemctl enable obfs-http.service
service obfs-http restart

# ss-v2ray
mv vps/shadowsocks/v2ray.json /etc/shadowsocks-libev/v2ray.json
mv vps/services/ss-v2ray.service /etc/systemd/system/ss-v2ray.service
systemctl enable ss-v2ray.service
service ss-v2ray restart

# install openvpn
cd
chmod +x vps/app/openvpn-install.sh
cd vps/app
./openvpn-install.sh

#install wireguard
cd
chmod +x vps/app/wireguard-install.sh
cd vps/app
./wireguard-install.sh

# install trojan
#cd
#apt-get -y install trojan
#sed -i 's/443/447/g' /etc/trojan/config.json
#sed -i 's/80/81/g' /etc/trojan/config.json
#sed -i 's@/path/to/certificate.crt@/etc/letsencrypt/live/sg01.hostervpn.com/fullchain.pem@g' /etc/trojan/config.json
#sed -i 's@/path/to/private.key@/etc/letsencrypt/live/sg01.hostervpn.com/privkey.pem@g' /etc/trojan/config.json
#sed -i 's@"password1",@"admin"@g' /etc/trojan/config.json
#sed -i '/"password2"/d' /etc/trojan/config.json
#sed -i 's@"fast_open": false,@"fast_open": true,@g' /etc/trojan/config.json
#systemctl enable trojan.service
#service trojan restart

# install pptp
cd
apt-get -y install pptpd
echo "localip 10.6.0.1" >> /etc/pptpd.conf
echo "remoteip 10.6.0.2-253" >> /etc/pptpd.conf
echo "ms-dns 1.1.1.1" >> /etc/ppp/pptpd-options
echo "ms-dns 1.0.0.1" >> /etc/ppp/pptpd-options
echo "admin pptpd admin *" >> /etc/ppp/chap-secrets
systemctl enable pptpd.service
service pptpd restart