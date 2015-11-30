#!/bin/bash -xe


MAIN_DIR=${1:-"/root/monitoring_scripts/"}
OUTPUT_DIR=${OUTPUT_DIR:-"/tmp/ceilometer_stats"}

mkdir -p $OUTPUT_DIR

if [[ `cat /etc/*-release | head -n 1 | awk '{print $1}'` =~ Ubuntu ]]; then
    apt-get install screen sysstat dstat iotop -y
else
    yum install screen sysstat dstat iotop -y
fi


write_iotop_stats(){
    output="$OUTPUT_DIR/$1-iotop_mongodb.log"
    screen -dmS iotopstats /bin/bash -c "$MAIN_DIR/iotop_monitoring.sh $output"
}

write_dstat_stats(){
    screen -dmS dstatstats /bin/bash -c "dstat -T --disk --io --disk-util   --full --output $OUTPUT_DIR/$1-dstats.log"
}

write_iostat_stats(){
    output="$OUTPUT_DIR/$1-iostat.log"
    screen -dmS iostatstats /bin/bash -c "$MAIN_DIR/iostat_monitoring.sh $output"
}

echo "Output dir is $OUTPUT_DIR"
write_dstat_stats $(hostname)
write_iotop_stats $(hostname)
write_iostat_stats $(hostname)