#!/bin/bash
read -p "Username: " User
# Check If Username Exist, Else Proceed
egrep "^$User" /etc/passwd >/dev/null
if [ $? -eq 0 ]; then
echo -e "Username already exist!"
echo
exit 0
else
read -p "Password: " Pass
read -p "Active days: " Days
Today=`date +%s`
Days_Detailed=$(( $Days * 86400 ))
Expire_On=$(($Today + $Days_Detailed))
Expiration=$(date -u --date="1970-01-01 $Expire_On sec GMT" +%Y/%m/%d)
Expiration_Display=$(date -u --date="1970-01-01 $Expire_On sec GMT" '+%b %d, %Y')
useradd $User
usermod -s /bin/false $User
usermod -e  $Expiration $User
egrep "^$User" /etc/passwd >/dev/null
echo -e "$Pass\n$Pass\n"|passwd $User &> /dev/null
echo "$User - $Pass - $Expiration_Display" >> /root/user.txt
echo
echo -e "Host Address: sg01.hostervpn.com"
echo -e "Username: $User"
echo -e "Password: $Pass"
echo -e "OpenSSH Port: 22"
echo -e "OpenSSH+SSL Port: 442"
echo -e "Dropbear Port: 82, 443, 448"
echo -e "Dropbear+SSL Port: 443"
echo -e "UDPGW Port: 7100-7900"
echo -e "Squid Proxy: 80, 3128, 8080"
echo -e "Squid Proxy+SSL: 8000"
echo -e "OpenVPN TCP Port: 443"
echo -e "OpenVPN UDP Port: 1194"
echo -e "OpenVPN+SSL Port: 943"
echo -e "OpenVPN Cloak Port: 4435"
echo -e "OpenVPN Client: http://sg01.hostervpn.com:81/ovpn"
echo -e "Expired: $Expiration_Display"
echo
fi
