#!/usr/bin/env bash
set -e

if [ "${1:0:1}" = '-' ]; then
	set -- mongod "$@"
fi

# allow the container to be started with `--user`
if [ "$1" = 'mongod' -a "$(id -u)" = '0' ]; then
	chown -R mongodb /data/configdb /data/db
	exec gosu mongodb "$BASH_SOURCE" "$@"
fi

if [ "$1" = 'mongod' ]; then
	numa='numactl --interleave=all'
	if $numa true &> /dev/null; then
		set -- $numa "$@"
	fi
fi

exec "$@" --storageEngine rocksdb

#MONGO_ROOT_PASSWORD="root"
MONGO_USER=${MONGO_PASSWORD:-$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 13)}
MONGO_PASSWORD=${MONGO_PASSWORD:-$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 13)}
#MONGO_DATABASE="dev"

mongo admin --eval "db.getSiblingDB('admin').runCommand({setParameter: 1, internalQueryExecYieldPeriodMS: 1000});"
mongo admin --eval "db.getSiblingDB('admin').runCommand({setParameter: 1, internalQueryExecYieldIterations: 100000});"
mongo admin --eval "db.getSiblingDB('$MONGO_DATABASE').runCommand({setParameter: 1, internalQueryExecYieldPeriodMS: 1000});"
mongo admin --eval "db.getSiblingDB('$MONGO_DATABASE').runCommand({setParameter: 1, internalQueryExecYieldIterations: 100000});"
#mongo admin --eval "rs.initiate();"
##mongo admin --eval "rs.add('localhost:27017');"

if [ "$MONGO_ROOT_PASSWORD" ]; then
	mongo admin --eval "db.createUser({user: 'root', pwd: '$MONGO_ROOT_PASSWORD', roles:[{role:'root',db:'admin'}]});"
fi

if [ "$MONGO_PASSWORD" ]; then
	mongo admin --eval "db.createUser({user: '$MONGO_USER', pwd: '$MONGO_PASSWORD', roles:[{role:'root',db:'$MONGO_DATABASE'}]});"
fi
touch /data/db/.mongodb_password_set
echo mongodb://${MONGO_USER}:${MONGO_PASSWORD}@$(hostname):27017/${MONGO_DATABASE}
