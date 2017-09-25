#!/bin/bash

######## Switch turn on and test the connection #################


ip=$1

if (!ping -c 1 $ip) then
echo "Can not ping $ip"
echo "Usage: $0 <ip_address>"
exit 1
fi


echo "turn on #1"
echo -en "pset 1 1\r\nlogout\r\n" | nc $ip 23 >/dev/null
sleep 1
echo "turn on #2"
echo -en "pset 2 1\r\nlogout\r\n" | nc $ip 23 >/dev/null
sleep 1
echo "turn on #3"
echo -en "pset 3 1\r\nlogout\r\n" | nc $ip 23 >/dev/null
# you can keepo going on regarding how many units are under test.
