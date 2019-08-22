#!/usr/bin/env bash

DIR=$(dirname $0)

realpath() {
    [[ $1 = /* ]] && echo "$1" || echo "$PWD/${1#./}"
}

log() {
    if [[ "$(uname)" == "Linux" ]]
    then
        echo "$(date --rfc-3339="seconds") :: INFO :: $@"
    else
        echo "$(date) :: INFO :: $@"
    fi
}

SSH() {
    gcloud compute ssh $1 -- $2 # 2>> $DIR/../log/stderr.log
}

SCP() {
    gcloud compute scp --recurse $1 $2 # 2>> $DIR/../log/stderr.log
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

        sleep 1

    done

}


