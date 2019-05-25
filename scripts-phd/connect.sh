#!/bin/bash

if [[ -z "$1" ]]
then
	echo "First argument should be IP"
	exit 1
fi

if [[ -z "$2" ]]
then 
	echo "Second arg should be key (recommendation: $(( $( ovs-vsctl show | grep -oE 'key="[0-9]+"' | grep -oE "[0-9]+" | sort -n | tail -n 1 ) + 1 )))"
	exit 1
fi

vxname=vx$(( $(ovs-vsctl show | grep -Ei 'vx[0-9]+' | grep -oEi '[0-9]+' | sort -n | uniq | tail -n 1) + 1 ))
remoteip="$1"
key="$2"

ovs-vsctl --may-exist add-br br0

ovs-vsctl --may-exist add-port br0 br0-int -- set interface br0-int type=internal

if [[ $(ovs-vsctl show | grep "remote_ip=\"$remoteip\"" | wc -l) -gt 0 ]]
then 
    echo Already exists.
    exit 0
fi

ovs-vsctl add-port br0 $vxname -- set interface $vxname type=vxlan options:remote_ip=$remoteip options:key=$key




