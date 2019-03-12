#!/bin/bash

## ================= LOADING CONFIGURATIONS ================= #
echo " ======= LOADING CONFIGURATIONS ======"
. "utils/parse_yaml.sh"
eval $(parse_yaml config-satellite-tools.yml "cfg_")

## ================= FUNCTIONS SUBSCRIPTION ================= #

configureFirewallCMD(){
    echo " ======= CONFIGURE FIREWALL-CMD ========"
    echo ""
    echo " ======= CONFIGURING PORTS ========"
    firewall-cmd \
        --add-port="53/udp" --add-port="53/tcp" \
        --add-port="67/udp" --add-port="69/udp" \
        --add-port="80/tcp"  --add-port="443/tcp" \
        --add-port="5000/tcp" --add-port="5647/tcp" \
        --add-port="8000/tcp" --add-port="8140/tcp" \
        --add-port="9090/tcp"
    echo " ======= CONFIGURING PERMANENT ========"
    firewall-cmd --runtime-to-permanent
}

