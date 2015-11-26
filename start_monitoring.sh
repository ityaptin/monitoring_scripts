#!/bin/bash -xe


MAIN_DIR=${MAIN_DIR:-"/root/monitoring_scripts-master"}

if [[ $1 ]];
then
  MAIN_DIR=$1
fi

source ${MAIN_DIR}/start_controller_monitoring.sh ${MAIN_DIR}
source ${MAIN_DIR}/start_mongonode_io_monitoring.sh ${MAIN_DIR}
