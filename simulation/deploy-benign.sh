#!/bin/bash

# get current file directory
DIR="$(realpath $( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd ))"
cd $DIR
source $DIR/../base/include.sh

print_help() {
    echo "./deploy-benign.sh <VM NAME>"
}

REQUIRED_ARGS=1

# print help and exit if not enough args given
[[ $# -ge ${REQUIRED_ARGS} ]] || {
    print_help
    exit 1
}

# parse args
TARGET_VM="$1"

# ===================================================== #

SCP $DIR/scripts root@$TARGET_VM:

SSH root@$TARGET_VM "bash scripts/run-benign.sh"
