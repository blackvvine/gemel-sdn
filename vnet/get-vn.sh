#!/usr/bin/env bash

# get directory of current file
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

. $DIR/import.sh

gcp_name="$1"

if [[ -z "$gcp_name" ]]
then
    echo "VM name should be provided"
fi

host_mac=$(gcloud compute ssh --zone=us-east1-b $gcp_name -- bash -c 'ifconfig | grep br0 | grep -oE "(.{2}:){5}.{2}"')

host_mac=$(echo -n $host_mac | sed 's/\\r//g')
host_mac="${host_mac/$'\r'/}"

log "VM MAC address is $host_mac"

switch_ip=$(gcloud compute ssh --zone=us-east1-b $gcp_name -- sudo ovs-vsctl show | grep -oE 'remote_ip=".+"' | grep -oE '([0-9]+\.){3}[0-9]+')

log "switch IP is \"$switch_ip\""

vxlan_key=$(gcloud compute ssh --zone=us-east1-b $gcp_name -- sudo ovs-vsctl show | grep -oE 'key="[0-9]+"' | grep -oE '[0-9]+')

log "VXLAN key is $vxlan_key"

switch_gcp_name=$(gcloud compute instances list | grep $switch_ip | awk '{print $1}')

log "switch VM name is \"$switch_gcp_name\""

# find associated port on switch
switch_port=$(gcloud compute ssh --zone=us-east1-b $switch_gcp_name -- sudo ovs-vsctl show | grep -B 1000 "key=\"$vxlan_key\"" | grep -oE 'Port ".+"' | tail -n 1 | grep -oE '".+"' | cut -d"\"" -f2)

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

echo $vn_name
