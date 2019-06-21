#!/usr/bin/env bash

show_help() {
    echo -e "./set-gw.sh [GATEWAY OVERLAY IP]"
}

get_internal_gw() {
    ifconfig ens4 | grep -o "inet addr:[0-9.]\+" | grep -o "\([0-9]\+.\)\+" | xargs -Ix echo x1
}

get_internal_subnet() {
    # ifconfig ens4 | grep -o "inet addr:[0-9.]\+" | grep -o "\([0-9]\+.\)\+" | xargs -Ix echo x0/16
    echo "10.0.0.0/8"
}

gw_overlay_ip=$1

if [[ -z "$gw_overlay_ip" ]]
then
    show_help
    exit 1
fi

mkdir -p ~/.ssh

set -x

sudo ip route add $(get_internal_subnet) via $(get_internal_gw) # (google's internal ip range)
sudo route add default gw $gw_overlay_ip # (overlay ip of the gateway host which is used by br0-int)
sudo route del default gw $(get_internal_gw) # delete google default GW

set +x

