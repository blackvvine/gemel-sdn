#!/bin/bash

set -e

realpath() {
    [[ $1 = /* ]] && echo "$1" || echo "$PWD/${1#./}"
}

# get current file directory
DIR="$(realpath $( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd ))"
cd $DIR

print_help() {
    echo -e "Installs Snort on a remote machine on GCP"
    echo "./setup-snort.sh [VM NAME]"
    exit 0
}

log() {
    echo "$(date)" :: INFO :: $@""
    # echo "$(date --rfc-3339="seconds") :: INFO :: $@"
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

# copy ansible playbook to host
log "updating scripts in VM $NAME"
SCP $DIR/scripts $NAME:~ || exit 1

## install ansible
#SSH $NAME 'sudo apt-add-repository ppa:ansible/ansible -y'
#SSH $NAME 'sudo apt update'
#SSH $NAME 'sudo apt install -y ansible'

# install OVS
SSH $NAME 'sudo ansible-playbook scripts/snort.yml'

log "Success!"


