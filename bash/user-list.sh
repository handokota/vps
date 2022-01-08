#!/bin/bash
echo
echo "    USERNAME    |    EXP DATE    "
echo "---------------------------------"
while read user
do
ACCOUNT="$(echo $user | cut -d: -f1)"
ID="$(echo $user | grep -v nobody | cut -d: -f3)"
exp="$(chage -l $ACCOUNT | grep "Account expires" | awk -F": " '{print $2}')"
if [[ $ID -ge 1000 ]]; then
printf "%-17s %2s\n" "$ACCOUNT" "$exp"
fi
done < /etc/passwd
TOTAL="$(awk -F: '$3 >= 1000 && $1 != "nobody" {print $1}' /etc/passwd | wc -l)"
echo "---------------------------------"
echo "TOTAL ACCOUNT: $TOTAL"
echo
