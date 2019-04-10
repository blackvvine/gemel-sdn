#!/bin/bash


if [ -z "$1" ]
then
    echo "Argument 1 should be VM name"
    exit 1
fi

gcloud compute --project=phdandpeasant instances create "$1" --zone=us-east1-b --machine-type=n1-standard-1 --subnet=default --network-tier=PREMIUM --maintenance-policy=MIGRATE --service-account=919881239930-compute@developer.gserviceaccount.com --scopes=https://www.googleapis.com/auth/devstorage.read_only,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring.write,https://www.googleapis.com/auth/servicecontrol,https://www.googleapis.com/auth/service.management.readonly,https://www.googleapis.com/auth/trace.append --image=ubuntu-1604-xenial-v20190325 --image-project=ubuntu-os-cloud --boot-disk-size=15GB --boot-disk-type=pd-standard --boot-disk-device-name=switch-vm2

