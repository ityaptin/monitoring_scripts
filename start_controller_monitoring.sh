#!/bin/bash -xe

MAIN_DIR=${1:-"/root/monitoring_scripts"}
OUTPUT_DIR=${OUTPUT_DIR:-"/tmp/ceilometer_stats"}

mkdir -p $OUTPUT_DIR

if [[ `cat /etc/*-release | head -n 1 | awk '{print $1}'` =~ Ubuntu ]]; then
    apt-get install screen sysstat dstat iotop -y
else
    yum install screen sysstat dstat iotop -y
fi

run_mongo_stats_scripts(){
    mongourl=$(cat /etc/ceilometer/ceilometer.conf | grep "^[^#].*mongo" | sed 's:connection *= *::; s:ceilometer:admin:g')
    screen -dmS mongodbstats ${MAIN_DIR}/mongo_stats.py --url ${mongourl} --result ${OUTPUT_DIR}/$1-mongo-stats.log
}

run_rabbit_stats_scripts(){
    screen -dmS rabbitmqstats /bin/bash -c "${MAIN_DIR}/rabbitmq_stats.sh ${OUTPUT_DIR}/$1-rabbitmq_stats.log 5"
}

run_rabbitctl_stats_scripts(){
    screen -dmS rabbitmqctlstats /bin/bash -c "${MAIN_DIR}/rabbitmqctl_stats.sh ${OUTPUT_DIR}/$1-rabbitmqctl_stats.log 5"
}

run_ps_stats_scripts(){
    screen -dmS psstats /bin/bash -c "${MAIN_DIR}/ceilometer_ps_stats.sh ${OUTPUT_DIR}/$1-ps-stats.log 5"
}


echo "Output dir is $OUTPUT_DIR"
run_mongo_stats_scripts "$(hostname)"
run_rabbit_stats_scripts "$(hostname)"
run_ps_stats_scripts "$(hostname)"
run_rabbitctl_stats_scripts "$(hostname)"