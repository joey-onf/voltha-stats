#!/bin/bash
## -----------------------------------------------------------------------
## Intent: Report on image download styats by repository
## -----------------------------------------------------------------------

declare -A ARGV=()
declare -a repos=()
while [ $# -gt 0 ]; do
    arg="$1"; shift
    case "$arg" in
	-*markup) ARGV['markup']=1 ;;
	-*repo) repos+=("$1"); shift ;;
	-*) echo "[SKIP] Unknown switch $arg" ;;
	*)
	    if [ -f "$arg" ]; then
		readarray -t repos < <(cat "$arg")
	    else
		repos+=("$arg")
	    fi
	    ;;
    esac
done

if [ ${#repos[@]} -eq 0 ]; then
    echo "ERROR: A repository name is required"
    exit 1
fi

api_v2="https://hub.docker.com/v2/repositories"


declare -a fields=()
fields+=('ONF')
fields+=('hub_user')
fields+=('status_description')
fields+=('pull_count')
fields+=('star_count')
fields+=('last_updated')
fields+=('description')

declare -a headers=('Repository' "${fields[@]}")

# HEADER
echo -n '|| '
for header in "${headers[@]}";
do
    echo -n "$header || "
done
echo

declare -A rec=()
declare -A count=()
for repo in "${repos[@]}";
do
    url="${api_v2}/$repo"

    raw="tmp/raw/${repo}"
    data="${raw}/data.json"
    mkdir -p "$raw"
    curl -o "$data" -s "$url"

    rec=(
	['Repository']="$repo"
	['ONF']="$repo"
    )

    for arg in "${fields[@]}";
    do
	readarray -t ans < <(jq -r ".${arg}" "$data")
	val="${ans[0]}"
	case "$arg" in
	    last_updated) val="${val:0:10}" ;;
	esac
	rec["$arg"]="$val"
    done

    echo -n '| '
    for hdr in "${headers[@]}";
    do
	val="${rec[$hdr]}"
	echo -n " $val | "
    done
    echo

done

echo "SUMMARY:"

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
