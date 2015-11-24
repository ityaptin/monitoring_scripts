#!/bin/bash -xe

echo "ID,PID,READ,WRITE,SWAPIN,IOUTIL,NAME" > $1
iotop -u mongodb -d 2 -o --time -qqq -k | awk '{line=($1","$2","$5","$7","$9","$11","$13); print line}' >> $1