#!/bin/bash

# api_v2="https://hub.docker.com/v2/repositories/voltha/voltha-envoy"
api_v2="https://hub.docker.com/v2/repositories"

readarray -t names < <(cat docker.names)

declare -A count=()
for name in "${names[@]}";
do
    echo "** name: $name"
    url="${api_v2}/$name"
    readarray -t ans < <(curl -s "$url" | jq -r ".pull_count")
    count["$name"]="${ans[0]}"
done

echo "SUMMARY:"
# declare -p count

log="voltha.repo.stats"
cat <<EOF>"$log"
# -----------------------------------------------------------------------
# IAM: Docker Stats: VOLTHA Images
# NOW: $(date '+%Y-%m-%d %H:%M:%S')
# -----------------------------------------------------------------------
EOF

declare -a lines=()
for key in "${!count[@]}"
do
    line=$(printf "%-50.50s : %s\n" "$key" "${count[$key]}")
    echo "$line"
    echo "$line" >> "$log"
done

# [EOF]
