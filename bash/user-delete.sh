#!/bin/bash
read -p "Username: " User
echo
sleep 2
egrep "^$User" /etc/passwd >/dev/null
if [ $? -eq 0 ]; then
userdel -f $User
echo -e "User deleted!"
echo
else
echo -e "User doesn't exist!"
echo
fi
