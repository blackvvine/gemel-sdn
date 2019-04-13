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

# print help and exit if not enough args given
[ $# -ge 1 ] || {
    print_help
    exit 1
}

# parse args
NAME="$1"

log "Starting to install Snort on VM $NAME"

# copy local installation scripts to VM
log "Uploading installation scripts to VM"
SCP scripts $NAME:~ || exit 1

# install the Snort Pre-Requisites
log "Installing the Snort Pre-Requisites"
SSH $NAME 'sudo apt-get install -y build-essential libpcap-dev libpcre3-dev libdumbnet-dev bison flex'

# download and install the latest version of DAQ from the Snort website.
log "Downloading the latest version of DAQ from the Snort website"
SSH $NAME 'mkdir ~/snort_src && cd ~/snort_src && wget https://snort.org/downloads/snort/daq-2.0.6.tar.gz'

log "Installing DAQ"
SSH $NAME 'cd ~/snort_src && tar -xvzf daq-2.0.6.tar.gz && cd daq-2.0.6 && ./configure && make && sudo make install'

# install libraries
log "Installing libraries: zlibg-dev, liblzma-dev, openssl, libssl-dev libnghttp2-dev"
SSH $NAME 'sudo apt-get install -y zlib1g-dev liblzma-dev openssl libssl-dev libnghttp2-dev'

log "Installing LuaJIT"
SSH $NAME 'cd ~/snort_src && wget http://luajit.org/download/LuaJIT-2.0.5.tar.gz && tar zxf LuaJIT-2.0.5.tar.gz && cd LuaJIT-2.0.5 && make && sudo make install'

# install Snort
log "Installing Snort-2.9.13"
SSH $NAME 'cd ~/snort_src && wget https://www.snort.org/downloads/snort/snort-2.9.13.tar.gz && tar xvzf snort-2.9.13.tar.gz && cd snort-2.9.13 && ./configure --enable-sourcefire && make && sudo make install && sudo ldconfig && sudo ln -s /usr/local/bin/snort /usr/sbin/snort && snort -V'

log "success!"
