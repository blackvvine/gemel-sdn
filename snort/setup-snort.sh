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
    gcloud compute ssh root@$1 -- $2
}

SCP() {
    gcloud compute scp --recurse $1 root@$2
}

# print help and exit if not enough args given
[ $# -ge 1 ] || {
    print_help
    exit 1
}

# parse args
NAME="$1"

# copy ansible playbook to host
log "Updating scripts in VM $NAME"
SCP $DIR/scripts $NAME:~ || exit 1

## install ansible
#log "Install latest Ansible"
#SSH $NAME 'sudo apt-add-repository ppa:ansible/ansible -y'
#SSH $NAME 'sudo apt update'
#SSH $NAME 'sudo apt install -y ansible'
#
## install Snort
SSH $NAME 'sudo ansible-playbook scripts/snort.yml'

#log "Enable gateway"
#SSH $NAME 'sudo ~/scripts/enable-gw.sh'

#log "Set-up Snort circuit"
#SSH $NAME 'sudo ~/scripts/setup-circuit.sh'

log "Success!"


