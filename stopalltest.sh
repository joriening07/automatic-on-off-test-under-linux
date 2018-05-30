#!/bin/bash

pkill -9 expect
pkill -9 port

ip=192.168.0.2

echo "powering all units"

echo -en "pset 1 0\r\nlogout\r\n"|nc $ip 23>/dev/null
echo -en "pset 2 0\r\nlogout\r\n"|nc $ip 23>/dev/null
echo -en "pset 3 0\r\nlogout\r\n"|nc $ip 23>/dev/null
echo -en "pset 4 0\r\nlogout\r\n"|nc $ip 23>/dev/null
echo -en "pset 5 0\r\nlogout\r\n"|nc $ip 23>/dev/null

ip=192.168.0.3

echo -en "pset 1 0\r\nlogout\r\n"|nc $ip 23>/dev/null
echo -en "pset 2 0\r\nlogout\r\n"|nc $ip 23>/dev/null
echo -en "pset 3 0\r\nlogout\r\n"|nc $ip 23>/dev/null
echo -en "pset 4 0\r\nlogout\r\n"|nc $ip 23>/dev/null
echo -en "pset 5 0\r\nlogout\r\n"|nc $ip 23>/dev/null

