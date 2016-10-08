#!/usr/bin/env bash
set -e

if [ "${1:0:1}" = '-' ]; then
    set -- mongod "$@"
fi

if [ "$1" = 'mongod' -a "$(id -u)" = '0' ]; then
	chown -R mongodb /data/configdb /data/db
	exec gosu mongodb "$BASH_SOURCE" "$@"
else
    if [ "$1" = 'mongod' ]; then
            numa='numactl --interleave=all'
            if $numa true &> /dev/null; then
                    set -- $numa "$@"
            fi
    fi
    exec "$@" --storageEngine rocksdb
fi
