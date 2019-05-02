#!/bin/bash

# get current file directory
DIR="$(realpath $( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd ))"
cd $DIR
source $DIR/../base/include.sh

print_help() {
    echo "{ help under construction }"
}

REQUIRED_ARGS=1

# print help and exit if not enough args given
[[ $# -ge ${REQUIRED_ARGS} ]] || {
    print_help
    exit 1
}

# parse args
VM_NAME="$1"


# ===================================================== #

log "Deploying simulation to $VM_NAME"
SSH root@$VM_NAME "git clone https://github.com/haifa-foundation/haifa_simulation.git /root/haifa_simulation"

