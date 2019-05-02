#!/usr/bin/env bash

realpath() {
    [[ $1 = /* ]] && echo "$1" || echo "$PWD/${1#./}"
}

log() {
    echo "$(date)" :: INFO :: $@""
    # echo "$(date --rfc-3339="seconds") :: INFO :: $@"
}

SSH() {
    gcloud compute ssh $1 -- $2
}

SCP() {
    gcloud compute scp --recurse $1 $2
}

wait_for() {

    NAME=$1

    while [ true ]
    do

        log "Waiting for VM to boot"
        SSH $NAME uptime

        if [ $? -eq 0 ]
        then
            break
        fi

    done

}

