#!/usr/bin/env bash

# get directory of current file
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# load globals
. $DIR/import.sh

print_help() {
    echo "Usage: ./reassign-vn.sh [VM INSTANCE NAME IN GCP]"
}

if [ $# -eq 0 ]
then
    print_help
    exit 0
fi

gcp_name=$1
current_vn=$2

if [[ -z "$gcp_name" || -z "$current_vn" ]]
then
    print_help
    exit 1
fi

if [[ "$current_vn" == "vnet1" ]]
then
    gateway="rl-gw"
elif [[ "$current_vn" == "vnet2" ]]
then
    gateway="rl-gw2"
else
    echo "Unknown vn $current_vn"
    exit 1
fi


NAT_GSSH() {
    escaped=$(printf "%q" "$2")
    res=$($GSSH root@$gateway -- ssh $1 "bash -c \"$escaped\"")
    echo "$res" | sed -e 's/\r//g'
}

# echo "Removing host $gcp_name from VN $vn_name"

host_mac=$(NAT_GSSH $gcp_name 'ifconfig | grep br0 | grep -oE "(.{2}:){5}.{2}"')

host_mac=$(echo -n $host_mac | sed 's/\\r//g')
host_mac="${host_mac/$'\r'/}"

log "VM MAC address is $host_mac"


switch_ip=$(NAT_GSSH $gcp_name "sudo ovs-vsctl show | grep -oE 'remote_ip=\".+\"' | grep -oE '([0-9]+\.){3}[0-9]+'")

log "switch IP is \"$switch_ip\""

vxlan_key=$(NAT_GSSH $gcp_name "ovs-vsctl show | grep -oE 'key=\\\"[0-9]+\\\"' | grep -oE '[0-9]+' ")

log "VXLAN key is $vxlan_key"


switch_gcp_name=$(gcloud compute instances list | grep $switch_ip | awk '{print $1}')

log "switch VM name is \"$switch_gcp_name\""

# find associated port on switch
switch_port=$($GSSH $switch_gcp_name -- sudo ovs-vsctl show | grep -B 1000 "key=\"$vxlan_key\"" | grep -oE 'Port ".+"' | tail -n 1 | grep -oE '".+"' | cut -d"\"" -f2)

log "VM ingress port is interface \"$switch_port\" @ $switch_gcp_name"

# call topology API to find openflow ID of switch
bash $DIR/get_topology.sh

# extract openflow ID of switch from topology API results
ids="$(python "$DIR/get_id.py" "$DIR/out.xml" "$host_mac")" || exit 1
switch_id=$(echo "$ids" | tail -n 1)

log "OpenFlow ID of the switch is $switch_id"

log "Finding current virtual network"
vn_name=$(curl --silent --user $ODL_API_USER:$ODL_API_PASS -X GET $ODL_API_URL/restconf/operational/vtn:vtns/ \
          | jq -r ".vtns.vtn[] | select(.vbridge[] | .vinterface[] | .[\"port-map-config\"][\"node\"] == \"$switch_id\" and .[\"port-map-config\"][\"port-name\"] == \"$switch_port\") | .name" | uniq)

log "current network is $vn_name"

echo $vn_name

