set -euo pipefail
out_directory="$STATE_DIRECTORY" # same; where final outputs are moved

# hblock options. there are more references for these options, but as for
# outputting okay enough rpz, i mostly referenced this script:
# https://github.com/hectorm/hblock/blob/a44b8b0a756af29a878280e39d2d23a57e976dae/resources/alt-formats/rpz.txt.sh

# shellcheck disable=SC2155
export HBLOCK_HEADER="$(cat <<-'EOF'
$TTL 2h
@ IN SOA star.wg.foxgirl.tech. rpz.foxgirl.tech. (1 6h 1h 1w 2h)
    IN NS  star.wg.foxgirl.tech.
EOF
)"
export HBLOCK_FOOTER=''
#export HBLOCK_SOURCES="file://${source:?}"
export HBLOCK_ALLOWLIST_FILE='/etc/hblock/allow.list'
export HBLOCK_DENYLIST='hblock-check.molinero.dev'

export HBLOCK_REDIRECTION='.'
export HBLOCK_WRAP='1'
export HBLOCK_TEMPLATE='%D CNAME %R'
export HBLOCK_COMMENT=';'

export HBLOCK_LENIENT='false'
export HBLOCK_REGEX='false'
export HBLOCK_FILTER_SUBDOMAINS='false'
export HBLOCK_CONTINUE='false'

hblock --output "$out_directory/hblock.rpz"