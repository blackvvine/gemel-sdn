
ODL_API_URL="http://35.196.130.113:8080"
ODL_API_USER=admin
ODL_API_PASS=admin

log() {
    echo "$(date) :: INFO :: $@"
    # echo "$(date --rfc-3339="seconds") :: INFO :: $@"
}

crash() {
    echo Error
    exit 1
}
