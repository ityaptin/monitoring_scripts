#!/bin/bash -xe

echo 'TIME,DEVICE,RPS,WPS,RPSkb,WPSkb,UTIL' > $1;
ubuntu=false
if [[ `cat /etc/*-release | head -n 1 | awk '{print $1}'` =~ Ubuntu ]]; then
    ubuntu=true
fi

while true; do
    if [[ $ubuntu ]];
    then
        lines=$(iostat -kx | awk -v d=$(date +%s) 'NR>=7 {print d","$1","$4","$5","$6","$7","$14}');
    else
        #iostat 9.0.4 in Centos have only 12 meters. Last meter is io util
        lines=$(iostat -kx | awk -v d=$(date +%s) 'NR>=7 {print d","$1","$4","$5","$6","$7","$12}');
    fi
    for line in ${lines[*]}; do
        echo $line >> $1
    done
    sleep 1;
done
