#!/bin/bash -xe

MAIN_DIR=${1:-"/root/monitoring_scripts"}
OUTPUT_DIR=${OUTPUT_DIR:-"/tmp/mongo_stats_collecting"}

mkdir -p $OUTPUT_DIR

run_mongo_stats_scripts(){
    mongourl=$(cat /etc/ceilometer/ceilometer.conf | grep "^[^#].*mongo" | sed 's:connection *= *::; s:ceilometer:admin:g')
    screen -dmS mongodbstats ${MAIN_DIR}/mongo_stats.py --url $mongourl --result ${OUTPUT_DIR}/$1-mongo-stats.log
}

run_rabbit_stats_scripts(){
    screen -dmS rabbitmqstats /bin/bash -c "${MAIN_DIR}/rabbitmq_stats.sh ${OUTPUT_DIR}/$1-rabbitmq_stats.log 5"
}

run_ps_stats_scripts(){
    screen -dmS psstats /bin/bash -c "${MAIN_DIR}/ceilometer_ps_stats.sh ${OUTPUT_DIR}/$1-ps-stats.log 5"
}

run_mongo_stats_scripts "$(hostname)"
run_rabbit_stats_scripts "$(hostname)"
run_ps_stats_scripts "$(hostname)"
