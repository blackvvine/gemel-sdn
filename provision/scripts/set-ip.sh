#!/bin/bash


if [[ -z "$1" ]]
then
	echo "First arg should be desired IP addr for internal connection"
	exit 1
fi

ifconfig br0-int $1 mtu 1450 up


