#!/bin/bash

while true

do 
    find/&>dev/tty1
    if[$(cat /proc/uptime | cut -fl -d''|cut -fl -d '.')-gt 300];then
        echo "DONE"
        sleep 0.5
        echo -en "\a">/dev/tty1
        sleep 0.5
        echo -en "\a">/dev/tty1
        exit 1
    fi
done
