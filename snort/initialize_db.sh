#!/bin/bash

print_help() {
    echo -e "initialize MySQL database on the VM"
    echo "./initialize_db.sh [VM NAME]"
    exit 0
}

log() {
    echo "$(date)" :: INFO :: $@""
}

SSH() {
    gcloud compute ssh $1 -- $2
}

SCP() {
    gcloud compute scp --recurse $1 $2
}

# print help and exit if not enough args given
[ $# -ge 1 ] || {
    print_help
    exit 1
}

# parse args
NAME="$1"

log "Starting to initialize MySQL database on VM $NAME"
# copy local installation scripts to VM
log "Uploading installation scripts to VM"
SCP scripts $NAME:~ || exit 1

log "Executing MySQL queries"
SSH $NAME 'sudo ~/scripts/queries.sh'

log "success!"