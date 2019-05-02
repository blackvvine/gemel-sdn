#!/bin/bash

# KEY=config.json

show_help(){
    echo "Usage: ./gcp-login.sh --credentials [GCP SERVICES JSON]"
    exit
}

PARAMS=""
while (( "$#" )); do
  case "$1" in
    -c|--credentials)
      KEY=$2
      shift 2
      ;;
    -h|--help)
	show_help
	shift 2
	;;
    --) # end argument parsing
      shift
      break
      ;;
    *) # preserve positional arguments
      PARAMS="$PARAMS $1"
      shift
      ;;
  esac
done

[ -n "$KEY" ] || show_help

echo Using key file: $KEY


gcloud auth activate-service-account --key-file=$KEY



