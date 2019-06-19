#!/bin/bash

# get current file directory
DIR="$(realpath $( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd ))"
cd $DIR
source $DIR/../base/include.sh

print_help() {
    echo "./deploy-controller.sh NAME [ ZONE ]"
}

REQUIRED_ARGS=1

# print help and exit if not enough args given
[[ $# -ge ${REQUIRED_ARGS} ]] || {
    print_help
    exit 1
}

# parse args
NAME="$1"
ZONE="$2"

if [[ -z "$ZONE" ]]
then
    ZONE="us-east1-b"
fi


# ===================================================== #

log "Creating VM $NAME"
./create-vm.sh $NAME "b" $ZONE

wait_for $NAME

log "#############################"
log "VM $NAME active"
log "#############################"

# copy ansible playbook to host
log "Updating scripts in VM"
SCP scripts root@$NAME:~ || exit 1

# install ansible
SSH root@$NAME 'apt-add-repository ppa:ansible/ansible -y'
SSH root@$NAME 'apt update'
SSH root@$NAME 'apt install -y ansible'

# install OVS
SSH root@$NAME 'sudo ansible-playbook scripts/odl.yml'


