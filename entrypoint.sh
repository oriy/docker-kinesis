#!/usr/bin/env bash
set -eo pipefail
shopt -s nullglob

kinesalite=/usr/bin/kinesalite
dynalite=/usr/bin/dynalite

echo "$kinesalite $@"
exec $kinesalite $@ &
pid=$!

./init_streams.sh

echo "${dynalite} --ssl --port 4568"
exec $dynalite --ssl --port 4568 &

wait $pid