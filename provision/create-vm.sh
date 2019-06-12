#!/bin/bash


TYPE="a"
ZONE="us-east1-b"

# Parse name
if [[ -z ${1+x} ]]
then
    echo "Usage: ./create-vm.sh name [type] [zone]"
    exit 1
fi

# Parse type
[[ -z ${2+x} ]] || {
    TYPE="$2"
}

[[ -z ${3+x} ]] || {
    ZONE="$3"
}

echo "Deploying type $TYPE instance"


if [[ "$TYPE" = "a" ]]
then

    gcloud compute --project=phdandpeasant instances create "$1" --zone="$ZONE" --machine-type=n1-standard-1 --subnet=default --network-tier=PREMIUM --maintenance-policy=MIGRATE --service-account=919881239930-compute@developer.gserviceaccount.com --scopes=https://www.googleapis.com/auth/devstorage.read_only,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring.write,https://www.googleapis.com/auth/servicecontrol,https://www.googleapis.com/auth/service.management.readonly,https://www.googleapis.com/auth/trace.append --image=ubuntu-1604-xenial-v20190325 --image-project=ubuntu-os-cloud --boot-disk-size=15GB --boot-disk-type=pd-standard --boot-disk-device-name="$1"

elif [[ "$TYPE" = "b" ]]
then

    gcloud compute --project=phdandpeasant instances create "$1" --zone="$ZONE" --machine-type=n1-standard-8 --subnet=default --network-tier=PREMIUM --maintenance-policy=MIGRATE --service-account=919881239930-compute@developer.gserviceaccount.com --scopes=https://www.googleapis.com/auth/devstorage.read_only,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring.write,https://www.googleapis.com/auth/servicecontrol,https://www.googleapis.com/auth/service.management.readonly,https://www.googleapis.com/auth/trace.append --tags=webserver --image=ubuntu-1604-xenial-v20190430 --image-project=ubuntu-os-cloud --boot-disk-size=20GB --boot-disk-type=pd-standard --boot-disk-device-name="$1"

else

    echo "Unknown type $TYPE"
    exit 1

fi


