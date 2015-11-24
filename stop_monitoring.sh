#!/bin/bash -xe

stop_screens() {
    scrs=$(screen -ls | egrep "stats" | awk {'print $1'})
    for i in $scrs; do screen -X -S $i quit; done
}

stop_screens