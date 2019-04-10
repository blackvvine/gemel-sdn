
# get directory of current file
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# load globals
. $DIR/import.sh

curl -u $ODL_API_USER:$ODL_API_PASS -H "Accept: application/xml" "$ODL_API_URL/restconf/operational/network-topology:network-topology/" | xmllint --format - | dd status=none of=$DIR/out.xml


