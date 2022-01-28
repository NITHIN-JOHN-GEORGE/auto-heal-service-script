#!/usr/bin/env bash

#Add the services seperated by space here for auto-healing

myservices=(docker nginx apache2) ## Declaring an array of services

MAIL_ID=njdevops321@gmail.com
HOST=$(hostname)
NOW=$(date +"%m-%d-%Y %H:%M:%S")

for serv in "${myservices[@]}"
do

if [[ -e $serv.info ]]
then
        rm -rf $serv.info
fi

pgrep $serv 2>/dev/null 1>/dev/null     ## CHECKING SERVICE
if [[ $? -eq 1 ]]       ## IF SERVICE IS NOT RUNNING
then
    sudo systemctl start $serv 2>/dev/null 1>/dev/null  ## TRY TO RESTART THE SERVICE
    pgrep $serv 2>/dev/null 1>/dev/null # CHECKING IF RESTARTING SERVICE WORKED

    if [[ $? -eq 0 ]]
    then
    echo "SERVICE RESTARTED" >> $serv.info
    echo "==================" >> $serv.info
    echo -e "\n" >>serv.info
    echo "$serv was down but restarted on $HOST at $NOW" >> $serv.info
    echo -e "\n" >>serv.info
    echo "==================" >> $serv.info

    cat $serv.info | mail -s "$serv Service Auto-Started since it was Stopped" -A $serv.info $MAIL_ID 1>/dev/null 2>/dev/null
    else
    echo "Ooops!!!! $serv is down on $HOST at $NOW , tried restarting but it didnot work " >> $serv.info
    cat $serv.info | mail -s "OOPS! Tried starting $serv But Failed .Please check !!!!" -A $serv.info $MAIL_ID
    fi
else
        echo "$serv is up and running" >> $serv.info
fi
done
