#!/bin/bash

if [ -z "$1" ]
then
    echo First arg should be controller IP
    exit 1
fi

ovs-vsctl set bridge br0 protocols=OpenFlow10 -- set-controller br0 tcp:$ip:6653



