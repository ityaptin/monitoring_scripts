#!/bin/bash -xe

echo 'TIME,DEVICE,RPS,KPS,RPSkb,KPSkb,UTIL' > $1;
while true; do
    line=$(iostat -kx | awk -v d=$(date +%s) 'NR>=7 {print d","$1","$4","$5","$6","$7","$14}');
    echo $line >> $1;
    sleep 1;
done
