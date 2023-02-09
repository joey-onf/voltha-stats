#!/bin/bash

# Working v2 API solution:
dtags () {
    local image="$1" ; shift
    local log="$1"   ; shift

    # "https://registry.hub.docker.com/v2/repositories/library/${image}/tags?page_size=1000"
    local url="https://registry.hub.docker.com/v2/repositories/${image}/tags"
    curl --silent "$url" > "$log"
}

# Original deprecated v1 API solution (I'm keeping this here for historic purposes):
# dtags () {
#    local image="${1}"
#
 #   curl --silent https://registry.hub.docker.com/v1/repositories/"${image}"/tags \
#        | tr -d '[]" ' | tr '}' '\n' | awk -F: '{print $3}' | sort --version-sort
#}

##----------------##
##---]  MAIN  [---##
##----------------##
# dtags 'debian'
# dtags 'voltha'
# dtags 'voltha/voltha-shovel'

ts="$(date '+%Y%m%d%H%M%S')"
declare -a argv=("$*")
for name in "${argv[@]}";
do
    logdir="tags/$name"
    mkdir -p "$logdir"
    logfile="$logdir/${ts}.json"
    echo "** NAME: $name"
    dtags "$name" "$logfile"
    jq . "$logfile"
done
