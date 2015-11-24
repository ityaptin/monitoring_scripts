#!/bin/bash -xe

MAIN_DIR=${1:-"~/monitoring_scripts/"}
OUTPUT_DIR=${OUTPUT_DIR:-"/tmp/mongo_stats_collecting"}

mkdir -p $OUTPUT_DIR

run_mongo_stats_scripts(){
    mongourl=$("cat /etc/ceilometer/ceilometer.conf | grep "^[^#].*mongo" | sed 's:connection *= *::; s:ceilometer:admin:g'")
    screen -dmS mongodbstats python ${CEILOMETER_STATS_DIR}/mongo_stats.py --url $mongourl --result "$OUTPUT_DIR/$1-mongo-stats.log"
}

run_rabbit_stats_scripts(){
    rabbit_stats_cmd="$MAIN_DIR/rabbitmq_stats.sh ${OUTPUT_DIR}/$1-rabbitmq_stats.log 5"
    screen -dmS rabbitmqstats /bin/bash -c ${rabbit_stats_cmd}
}

run_ps_stats_scripts(){
    ps_cmd="${MAIN_DIR}/ceilometer_ps_stats.sh ${OUTPUT_DIR}/$1-ps-stats.log 5"
    screen -dmS psstats /bin/bash -c ${ps_cmd}
}

run_mongo_stats_scripts "$(hostname)"
run_rabbit_stats_scripts "$(hostname)"
run_ps_stats_scripts "$(hostname)"
