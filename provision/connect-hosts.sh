#!/bin/bash

# get current file directory
DIR="$(realpath $( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd ))"
cd $DIR
source $DIR/../base/include.sh

print_help() {
    echo "{ help under construction }"
}

REQUIRED_ARGS=2

# print help and exit if not enough args given
[[ $# -ge ${REQUIRED_ARGS} ]] || {
    print_help
    exit 1
}

# parse args
VM1="$1"
VM2="$2"


# ===================================================== #

function get_ip_of() {
    echo $(SSH $1 'ifconfig ens4' | grep -o 'inet addr:10.[0-9.]\+' | grep -o '10.[0-9.]\+')
}

# ===================================================== #

set -e

KEY=$RANDOM

SCP scripts root@$VM1:~/ || exit 1
SCP scripts root@$VM2:~/ || exit 1

IP1=$(get_ip_of $VM1)
IP2=$(get_ip_of $VM2)

echo "connecting $VM1 to $VM2 ($IP2)"
SSH root@$VM1 "./scripts/connect.sh $IP2 $KEY"

echo "connecting $VM2 to $VM1 ($IP1)"
SSH root@$VM2 "./scripts/connect.sh $IP1 $KEY"


