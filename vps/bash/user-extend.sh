#!/bin/bash
echo
read -p "Username: " User
egrep "^$User" /etc/passwd >/dev/null
if [ $? -eq 0 ]; then
read -p "Day extend: " Days
Today=`date +%s`
Days_Detailed=$(( $Days * 86400 ))
Expire_On=$(($Today + $Days_Detailed))
Expiration=$(date -u --date="1970-01-01 $Expire_On sec GMT" +%Y/%m/%d)
Expiration_Display=$(date -u --date="1970-01-01 $Expire_On sec GMT" '+%b %d, %Y')
passwd -u $User
usermod -e  $Expiration $User
egrep "^$User" /etc/passwd >/dev/null
echo -e "$Pass\n$Pass\n"|passwd $User &> /dev/null
echo "$User - $Expiration_Display" >> /root/user.txt
clear
echo -e "Username: $User"
echo -e "Days added: $Days Days"
echo -e "Expires on: $Expiration_Display"
echo
else
clear
echo -e "Username doesn't exist"
echo
fi
