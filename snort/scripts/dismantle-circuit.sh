#!/usr/bin/env bash

set -e

int=$(ovs-ofctl show br0 | grep -E '([[:digit:]]+)\(br0-int' | cut -d'(' -f1 | sed 's/ //g')
vx1=$(ovs-ofctl show br0 | grep -E '([[:digit:]]+)\(vx1' | cut -d'(' -f1 | sed 's/ //g')
ingress=$(ovs-ofctl show br0 | grep -E '([[:digit:]]+)\(ingress' | cut -d'(' -f1 | sed 's/ //g')
egress=$(ovs-ofctl show br0 | grep -E '([[:digit:]]+)\(egress' | cut -d'(' -f1 | sed 's/ //g')

int_mac=$(ifconfig br0-int | grep -oi 'hwaddr .*' | cut -f2 -d" ")

gw_overlay=$(ifconfig br0-int | grep -oE 'inet addr:[0-9.]+' | cut -d":" -f2)

echo int=$int vx1=$vx1 ingress=$ingress egress=$egress int_mac=$int_mac gw_overl=$gw_overlay

set -x

ovs-ofctl del-flows br0 in_port=$egress

ovs-ofctl del-flows br0 in_port=$vx1,dl_dst=01:00:00:00:00:00/01:00:00:00:00:00

ovs-ofctl del-flows br0 in_port=$vx1,dl_dst=$int_mac,dl_type=0x0800,nw_dst=$gw_overlay

ovs-ofctl del-flows br0 in_port=$vx1,dl_type=0x0800

ovs-ofctl del-flows br0 in_port=$vx1

set +x
