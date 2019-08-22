#!/bin/bash

# get current file directory
DIR="$(realpath $( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd ))"
cd $DIR
source $DIR/../base/include.sh

print_help() {
    echo "./set-host-gw.sh <HOST-NAME> <GATEWAY-NAME>"
}

REQUIRED_ARGS=2

# print help and exit if not enough args given
[[ $# -ge ${REQUIRED_ARGS} ]] || {
    print_help
    exit 1
}

# parse args
HOST="$1"
GATEWAY="$2"


# ===================================================== #

set -e

log "Copying keys and scripts to host $HOST"
SCP $DIR/../keys/gw.pub root@$HOST:
SCP $DIR/../provision/scripts/ root@$HOST:
SSH root@$HOST "cat /root/gw.pub >> /root/.ssh/authorized_keys"

log "Copying scripts to gateway"
SCP $DIR/../keys/gw root@$GATEWAY:/root/.ssh/
SCP $DIR/scripts root@$GATEWAY:
SSH root@$GATEWAY "chmod 600 /root/.ssh/gw"

log "Enabling packet forwarding on gateway"
SSH root@$GATEWAY "./scripts/enable-gw.sh"

HOST_IP=$(gcloud compute instances list | grep $HOST | awk '{ print $4 }')
log "Internal IP of the host is $HOST_IP"

log "Setting new routes for host $HOST"
SSH root@$GATEWAY "ssh -i /root/.ssh/gw -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no \"$HOST_IP\" \"./scripts/set-gw.sh 210.0.0.200\""

