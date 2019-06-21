#!/usr/bin/env bash

# 1.Enable ip forward on the gateway host
sudo sysctl -w net.ipv4.ip_forward=1

# 2.Change the default policy of the iptables FORWARD chain to accept all packets on the gateway host
sudo iptables -A FORWARD -j ACCEPT

# 3.Enable masquerading on the gateway host
sudo iptables -t nat -A POSTROUTING -o ens4 -j MASQUERADE

