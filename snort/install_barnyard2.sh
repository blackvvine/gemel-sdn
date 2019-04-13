#/!bin/bash

print_help() {
    echo -e "Install Barnyard2 on the VM"
    echo "./install_barnyard2.sh [VM NAME]"
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

log "Starting to install Barnyard2 on VM $NAME"

# log "Installing the Barnyard2 pre-requisites: mysql-server libmysqlclient-dev mysql-client autoconf libtool"
# SSH $NAME 'sudo apt-get install -y mysql-server libmysqlclient-dev mysql-client autoconf libtool'

log "Downloading Barnyard2"
SSH $NAME 'mkdir ~/barnyard2 && cd ~/barnyard2 && wget https://github.com/firnsy/barnyard2/archive/master.tar.gz -O barnyard2-Master.tar.gz'

log "Preparing for installation"
SSH $NAME 'cd ~/barnyard2 && tar zxvf barnyard2-Master.tar.gz && cd barnyard2-master && autoreconf -fvi -I ./m4 && sudo ln -s /usr/include/dumbnet.h /usr/include/dnet.h && sudo ldconfig'

log "Pointing the install to the correct MySQL libraray"
SSH $NAME 'cd ~/barnyard2/barnyard2-master && ./configure --with-mysql --with-mysql-libraries=/usr/lib/x86_64-linux-gnu'

log "Building and installing Barnyard2"
SSH $NAME 'cd ~/barnyard2/barnyard2-master && make && sudo make install && /usr/local/bin/barnyard2 -V'

log "Copying and creating some files that Barnyard2 requires to run"
SSH $NAME 'sudo cp ~/barnyard2/barnyard2-master/etc/barnyard2.conf /etc/snort/ && sudo mkdir /var/log/barnyard2 && sudo chown snort.snort /var/log/barnyard2 && sudo touch /var/log/snort/barnyard2.waldo && sudo chown snort.snort /var/log/snort/barnyard2.waldo'