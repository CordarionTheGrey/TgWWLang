#!/usr/bin/env bash

set -euo pipefail
IFS=$'\t\n'
[[ $# -eq 1 ]] || exit 2
readonly port=$1
cd -- "${0%/*}"

if [[ -z "${SOCKS5_SERVER-}${SOCKS4_SERVER-}${SOCKS_SERVER-}" ]]; then
    echo 'At least one of $SOCKS{5,4,}_SERVER should be set.' >&2
    # However, they can be set in `socks.conf` as well, so we don't terminate.
fi

readonly fifo=$(mktemp --dry-run)
mkfifo -m600 -- "$fifo"
trap 'rm -f -- "$fifo"' EXIT

nc -lk 127.0.0.1 -- "$port" <"$fifo" | socksify ./make_https_tunnel.pl api.telegram.org >"$fifo"
