#!/bin/bash

print_help() {
    echo -e "Install Snort on the VM"
    echo "./install_snort.sh [VM NAME]"
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

# parse args
NAME="$1"

log "Starting to install Snort on VM $NAME"

# copy local installation scripts to VM
log "Uploading installation scripts to VM"
SCP scripts $NAME:~ || exit 1

# install the Snort Pre-Requisites
log "Installing the Snort Pre-Requisites"
SSH $NAME 'sudo apt-get install -y build-essential'
SSH $NAME 'sudo apt-get install -y libpcap-dev libpcre3-dev libdumbnet-dev'
SSH $NAME 'sudo apt-get install -y bison flex'

# create a folder called snort_src to keep software packages all in one place
log "Creating a folder called snort_src"
SSH $NAME 'mkdir ~/snort_src && cd ~/snort_src'

# download and install the latest version of DAQ from the Snort website.
log "Downloading the latest version of DAQ from the Snort website"
SSH $NAME 'cd ~/snort_src && wget https://snort.org/downloads/snort/daq-2.0.6.tar.gz'

log "Installing DAQ"
SSH $NAME 'cd ~/snort_src && tar -xvzf daq-2.0.6.tar.gz && cd daq-2.0.6 && ./configure && make && sudo make install'








