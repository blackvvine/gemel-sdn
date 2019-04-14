#!/bin/bash

mkdir odl
cd odl

wget https://nexus.opendaylight.org/content/repositories/public/org/opendaylight/integration/distribution-karaf/0.6.2-Carbon/distribution-karaf-0.6.2-Carbon.tar.gz

tar -zxf distribution-karaf-0.6.2-Carbon.tar.gz

add-apt-repository ppa:webupd8team/java
apt update

apt-get install -y oracle-java8-installer

echo "export JAVA_HOME=/usr/lib/jvm/java-8-oracle/" >> ~/.bashrc
. ~/.bashrc

cd /root/odl/distribution-karaf-0.6.2-Carbon


bin/karaf

##########################################
#                                        #
#        Inside ODL shell                #
#                                        #
##########################################

feature:repo-refresh

feature:install odl-dluxapps-applications odl-restconf odl-l2switch-switch odl-mdsal-apidocs odl-openflowplugin-southbound odl-vtn-manager-rest

feature:install odl-dluxapps-applications odl-restconf odl-mdsal-apidocs odl-openflowplugin-southbound odl-vtn-manager-rest odl-l2switch-hosttracker

^D

##########################################
#                                        #
#        Back inside BASH                #
#                                        #
##########################################

ln -s /root/odl/distribution-karaf-0.6.2-Carbon /etc/sdn

echo -e "[Unit]\nDescription=OpenDayLight Controller\nAfter=network.target\n[Service]\nType=forking\nUser=root\nExecStart=/etc/sdn/bin/start\nRestart=on-abort\n[Install]\nWantedBy=multi-user.target" > /etc/systemd/system/opendaylight.service

systemctl daemon-reload
systemctl enable opendaylight

screen -d -m bash -c '/etc/sdn/bin/karaf server'


###########################################
###########################################

cd ~/odl/

# Install build dependencies

apt-get install pkg-config gcc make  ant g++ maven git libboost-dev libcurl4-openssl-dev libssl-dev openjdk-7-jdk unixodbc-dev libjson0-dev

apt-get install  postgresql-9.5 postgresql-client-9.5 postgresql-client-common postgresql-contrib-9.5 odbc-postgresql

apt-get install cmake libgtest-dev

# Make and install gtest-work
cd gtest-work
cmake CMakeLists.txt
make
sudo cp *.a /usr/lib
cd ..
rm -rf gtest-work

# Fix m2 settings

mkdir -p ~/.m2

cp -n ~/.m2/settings.xml{,.orig} ; \
wget -q -O - https://raw.githubusercontent.com/opendaylight/odlparent/master/settings.xml > ~/.m2/settings.xml

# checkout and make maven

cores=$(cat /proc/cpuinfo  | grep -E '^processor' | wc -l)

cd vtn
git clone https://github.com/opendaylight/vtn.git
git checkout release/oxygen
cd coordinator
mvn -T $cores -f dist/pom.xml install

./configure
make -j $cores
make install

# set up DB
/usr/local/vtn/sbin/db_setup


###########################################
###########################################

# Run VTN
/usr/local/vtn/bin/vtn_start

# check status
/usr/local/vtn/bin/unc_dmctl status

###########################################
###########################################

sudo ovs-vsctl set-controller br0 tcp:$controllerip:6633







