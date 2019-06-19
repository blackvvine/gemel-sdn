#!/usr/bin/env bash

apt install -y docker.io

service docker start

test -d ez-SYN-TCP-FLOOD && mkdir -p ez-SYN-TCP-FLOOD

git clone https://github.com/haifa-foundation/ez-SYN-TCP-FLOOD.git

cd ez-SYN-TCP-FLOOD

bash build.sh

bash run.sh
