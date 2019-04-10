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

feature:install odl-dluxapps-applications odl-restconf odl-mdsal-apidocs odl-openflowplugin-southbound odl-vtn-manager-rest odl-l2switch-hosttracker1

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

sudo ovs-vsctl set-controller br0 tcp:$controllerip:6633







