#!/bin/bash -xe

hostname=$(hostname)

log_file=$1
if [ -z "$log_file" ]; then
  log_file="/tmp/ceilometer_stats/${hostname}-rabbitmqctl-stats.log"
fi
sleep_time=$2
if [ -z "$sleep_time" ]; then
  sleep_time=2
fi

function write_ctl_stats(){
    echo -e "TIME\tHOSTNAME\tNAME\tCOUNT" > ${log_file}
    while true;
    do
        lines=$(rabbitmqctl list_queues name messages | grep -E "(notification)|(metering)|(event)")
        IFS=$'\n'
        while read i; do
            d=$(date +%s)
            echo -e "$d\t$hostname\t$i" >> ${log_file}
        done <<< "$lines"
        sleep ${sleep_time}
    done
}


while true; do
  sleep $sleep_time
  write_ctl_stats
done