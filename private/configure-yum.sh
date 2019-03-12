#!/bin/bash

## ================= LOADING CONFIGURATIONS ================= #
echo " ======= LOADING CONFIGURATIONS ======"
. "utils/parse_yaml.sh"
eval $(parse_yaml config-satellite-tools.yml "cfg_")

## ================= FUNCTIONS SUBSCRIPTION ================= #

yumPrepare(){
    echo " ======= CONFIGURE YUM BASICS ========"
    echo ""
    echo " ======= CLEAN ========"
    yum clean all
    echo " =======  VERIFY  ========"
    yum repolist enabled
    echo " =======  UPDATE  ========"
    yum -y update
}

yumInstallSatellite(){
    echo " =======  INSTALL PACKAGE SATELLITE  ========"
    yum -y update
    yum -y install satellite
}


yumInstallConfigureChronydAndSos(){
    yum -y install chrony
    systemctl start chronyd
    systemctl enable chronyd
    yum -y install sos
}