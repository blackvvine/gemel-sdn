#!/bin/bash

# get current file directory
DIR="$(realpath $( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd ))"
cd $DIR
source $DIR/../base/include.sh

print_help() {
    echo -e "Creates a new VM, installs VXLAN capable OVS on it,\n connects it to one of the so-called \"physical\" switches on the SDN lab through VXLAN."
    echo "./add-instance.sh [VM NAME] [ENTRY SWITCH NAME] [OVERLAY IP] [optional: VM TYPE]"
    exit 0
}

# print help and exit if not enough args given
[ $# -ge 3 ] || {
    print_help
    exit 1
}

# parse args
NAME="$1"
SWITCH="$2"
OVERLAY_IP="$3"
VM_TYPE="$4"

if [[ -z ${VM_TYPE+x} ]] 
then
    VM_TYPE="a"
fi

# command aliases for easy unanimous updating
# SSH="ssh -oStrictHostKeyChecking=no"
# SCP="scp -oStrictHostKeyChecking=no"

if [[ -z "$(gcloud compute instances list | grep $SWITCH)" ]]
then
    log "No such VM: $SWITCH"
    exit 1
fi

# create VM
log "creating VM $NAME of type $VM_TYPE"
$(realpath $DIR)/create-vm.sh $NAME $VM_TYPE || exit 1

# get VM IP address
VM_IP=$(gcloud compute instances list | grep $NAME | awk '{ print $5 }')
log "VM external IP address is $VM_IP"

# get switch IP address
SWITCH_IP=$(gcloud compute instances list | grep $SWITCH | awk '{ print $5 }')
log "switch external IP address is $SWITCH_IP"
log "updating scripts in switch"
SCP scripts $SWITCH:~/ || exit 1

# wait until SSH up
wait_for $NAME

# copy ansible playbook to host
log "updating scripts in VM"
SCP scripts $NAME:~ || exit 1

# install ansible
SSH $NAME 'sudo apt-add-repository ppa:ansible/ansible -y'
SSH $NAME 'sudo apt update'
SSH $NAME 'sudo apt install -y ansible'

# install OVS
SSH $NAME 'sudo ansible-playbook scripts/ovs.yml'

# generate random VXLAN key
VXLAN_KEY=$(shuf -i 1-2097151 -n 1)
log "generated VXLAN key is $VXLAN_KEY"

# connect switch to host
VM_INTERNAL_IP=$(gcloud compute instances list | grep "$NAME" | awk '{ print $4 }')
SW_INTERNAL_IP=$(gcloud compute instances list | grep "$SWITCH" | awk '{ print $4 }')
log "VM is at $VM_INTERNAL_IP and switch is at $SW_INTERNAL_IP internal VPC address"

log "establishing VM to switch link"
SSH $NAME "sudo ~/scripts/connect.sh $SW_INTERNAL_IP $VXLAN_KEY"

log "establishing switch to VM link"
SSH $SWITCH "sudo ~/scripts/connect.sh $VM_INTERNAL_IP $VXLAN_KEY"

# set overlay IP
log "set VM overlay IP to $OVERLAY_IP"
SSH $NAME "sudo ~/scripts/set-ip.sh $OVERLAY_IP"

log "Success!"


