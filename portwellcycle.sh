#!/bin/bash

#$1 is TTY
#$2 is PORT(AC Power),1 or 2
#$3 is IP address of the remote Synacces unit

tty=$1
outlet=$2
ip=$3

if[$#-ne 3]; then
    echo "error:usage:<USBn><power channel><synaccess_ip>"
    echo "example of usage: $0 USB0 1 172.16.14.1"
    exit 1
fi

if(!which expect);then
    echo "expect package is missing"
    echo "sudo apt-get update; sudo apt-get install expect"
    exit 1
fi

total=0
success=0
fail=0
count=0
busybox=0
nologin=0
noinit=0
unknown=0

trap ctrl_c INT

log_output(){
    logger tty=$tty success=$success fail=$fail busybox=$busybox init=$noinit nologin=$nologin
}

log_errors(){
    echo "****LOG UPDATE on 'date'*****************">>errorlog.${tty}
    echo "****LOG UPDATE on 'date'*****************">>alllog.${tty}
    cat output.${tty}>>errorlog.${tty}
    cat output.${tty}>>alllog.${tty}
}

ctrl_c(){
    logger STOPPED-tty=$tty success=$success fail=$fail busybox=$busy init=$noinit nologin=$nologin
    echo "*****LOG closed on 'date'***********">>errorlog.${tty}
    echo "*****LOG CLOSED ON 'date'***********">>alllog.${tty}
    echo "power off unit"
    echo -en "pset $outlet 0\r\nlogout\r\n"|nc $ip 23>/dev/null
    exit()
}
#power off
echo -en "pset $outlet 0\r\nlogout\r\n"|nc $ip 23>/dev/null
sleep 5

#timestamp outthe start of our new run
echo "*****Log opened on 'date'**********">>errorlog.${tty}
echo "****log opened on 'date'**********">>alllog.${tty}

logger STARTED-tty=$tty outlet=$outlet success=$success fail=$fail count=$count

while true
do
    :$((count++))
    echo "Turn power on"
    echo -en "pset $outlet 1\r\nlogout\r\n" | nc $ip 23>/dev/null
#run test
    ./powercycle.exp /dev/tty${tty}>output.${tty}
    RET_CODE=$?
    echo "expect script return code: $RET_CODE"
    if[ 0 = $RET_CODE ]; then
        :$(success++)
        echo "test passed"
        echo "****log update on 'date'*********">alllog.${tty}

#skip logging successful outcomes
## cat output.${tty}>>alllog.${tty}

    elif[ 1 = $RET_CODE ];then
        echo "General error"
        logger General_error-tty=$tty success=$success fail=$fail busybox=$busy init=$noinit nologin=$nologin
        echo -en "pset $outlet 0\r\nlogout\r\n" | nc $ip 23>/dev/null
    exit 1

    elif[ 2 = $RET_CODE ];then
        :$((fail++))
        echo "test failed"
        log_errors

    elif[ 5 = $RET_CODE ];then
        :$((busybox++))
        echo "busybox error"
        log_errors

    elif[ 6 = $RET_CODE ];then
        :$((noinit++))
        echo "missing init error"
        log_errors

    elif[ 6 = $RET_CODE ];then
        :$((nologin++))
        echo "no login error"
        log_errors

    else
        :$((unknown++))
        echo "unknown error"
        log_errors
    fi


    log_output
        echo -en "pset $outlet 0\r\nlogout\r\n"|nc $ip 23>/dev/null
        sleep 5

done
