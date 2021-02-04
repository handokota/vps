#!/bin/bash
if [ -e "/var/log/auth.log" ]; then
        LOG="/var/log/auth.log";
fi
if [ -e "/var/log/secure" ]; then
        LOG="/var/log/secure";
fi
data=( `ps aux | grep -i dropbear | awk '{print $2}'`);
echo "DROPBEAR USER LOGIN";
echo "-----------------------------------";
echo " PID |  USERNAME  |   IP ADDRESS   ";
echo "-----------------------------------";
cat $LOG | grep -i dropbear | grep -i "Password auth succeeded" > /tmp/login-db.txt;
for PID in "${data[@]}"
do
cat /tmp/login-db.txt | grep "dropbear\[$PID\]" > /tmp/login-db-pid.txt;
NUM=`cat /tmp/login-db-pid.txt | wc -l`;
USER=`cat /tmp/login-db-pid.txt | awk '{print $10}'`;
IP=`cat /tmp/login-db-pid.txt | awk '{print $12}'`;
if [ $NUM -eq 1 ]; then
echo "$PID - $USER - $IP";
fi
done
echo
echo "OPENSSH USER LOGIN";
echo "-----------------------------------";
echo " PID |  USERNAME  |   IP ADDRESS   ";
echo "-----------------------------------";
cat $LOG | grep -i sshd | grep -i "Accepted password for" > /tmp/login-db.txt
data=( `ps aux | grep "\[priv\]" | sort -k 72 | awk '{print $2}'`);
for PID in "${data[@]}"
do
cat /tmp/login-db.txt | grep "sshd\[$PID\]" > /tmp/login-db-pid.txt;
NUM=`cat /tmp/login-db-pid.txt | wc -l`;
USER=`cat /tmp/login-db-pid.txt | awk '{print $9}'`;
IP=`cat /tmp/login-db-pid.txt | awk '{print $11}'`;
if [ $NUM -eq 1 ]; then
echo "$PID - $USER - $IP";
fi
done
if [ -f "/var/log/openvpn/status.log" ]; then
line=`cat /var/log/openvpn/status.log | wc -l`
a=$((3+((line-8)/2)))
b=$(((line-8)/2))
echo
echo "OPENVPN USER LOGIN"
echo "---------------------------------------------------------";
echo " USER |       IP ADDRESS       |     CONNECTED SINCE     ";
echo "---------------------------------------------------------";
cat /var/log/openvpn/status.log | head -n $a | tail -n $b | cut -d "," -f 1,2,5 | sed -e 's/,/   /g' > /tmp/vpn-login-db.txt
cat /tmp/vpn-login-db.txt
fi
echo
