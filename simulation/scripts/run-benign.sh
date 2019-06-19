#!/usr/bin/env bash

apt install -y docker.io

service docker start

git clone https://github.com/haifa-foundation/puppet-master

cd puppet-master
git checkout orange

bash build.sh

bash run-script.sh google benign
