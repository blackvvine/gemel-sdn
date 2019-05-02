#!/usr/bin/env bash

show_help() {
    echo -e "./set-gw.sh [GATEWAY OVERLAY IP]"
}

gw_overlay_ip=$1

if [[ -z "$gw_overlay_ip" ]]
then
    show_help
    exit 1
fi

mkdir -p ~/.ssh

set -x

pubkey="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDLMdueHvybfuxc9/DRGkTGLUpA+lkIJ6a7+sb5SUWMLDRuzrzEMle7Bg/H6wUd9Qb7E9feZAKmy2PFnc7K4/E45MjhBIHajzr4k1Eo62hnQS3RK4bUiCkqWA4fsADOZsDtb3IpPpoQtqKhyhVxCru0Fhz4+0z2ktJcOiLWRyQfjFtHYxh2nu/L3juPDY0fi09fmAakNfw1L5RfHoJw3XhGuS5lGm4A7SdO7kWUjS48zFNtweR5+5nSB6kgc6sM1qJ+up1XMu8C6MueHqA7N7gha+3YlrajM3hORm0WhqabQHpthwcU0jXw7aiqzkDn5nbkrdf/hYSgolR5JCWK/Xjp blackvvine@BlueSkies"

echo $pubkey >> ~/.ssh/authorized_keys

sudo ip route add 10.142.0.0/16 via 10.142.0.1 # (google's internal ip range)
sudo route add default gw $gw_overlay_ip # (overlay ip of the gateway host which is used by br0-int)
sudo route del default gw 10.142.0.1 # delete google default GW

set +x

