#!/bin/bash -xe

stat_names=( messages publish_rate deliver_rate )
names=( notifications.info metering.sample )
hostname=$(hostname)

log_file=$1
if [ -z "$log_file" ]; then
  log_file="/tmp/ceilometer_stats/${hostname}-rabbit-stats.log"
fi
sleep_time=$2
if [ -z "$sleep_time" ]; then
  sleep_time=5
fi

user=nova
password=($(grep -A 1 'rabbit:' /etc/astute.yaml | grep 'password' | awk '{print $2}'))

function write_admin_stats() {
    for name in ${names[*]}; do
      stats_line=($(rabbitmqadmin -u $user -p $password list queues name messages message_stats.publish_details.rate message_stats.deliver_details.rate | grep $name | awk '{print $4,$6,$8}'))
      ts=$(date +%s)
      for i in {0..2}; do
        echo -e "GAUGE\t${hostname}\trabbitmq/${name}_${stat_names[($i)]}\t${ts}\t${stats_line[($i)]}" >> ${log_file}
      done
    done
}

function write_ctl_stats(){
    lines=$(rabbitmqctl list_queues name messages | grep -E "(notification)|(metering)|(event)")
    IFS=$'\n'
    while read i; do
    d=$(date +%s)
    echo -e "$d\t$i" >>
    done <<< "$lines"
}


echo "" > ${log_file}
while true; do
  sleep $sleep_time
  write_admin_stats
done