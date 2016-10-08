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
    exec "$@" --storageEngine rocksdb &
fi

sleep 1

set +e
#MONGO_ROOT_PASSWORD="root"
#MONGO_USER=${MONGO_PASSWORD:-$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 13)}
#MONGO_PASSWORD=${MONGO_PASSWORD:-$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 13)}
MONGO_ROOT_PASSWORD=$(hostname)
MONGO_USER=$(hostname)
MONGO_PASSWORD=$(hostname)
#MONGO_DATABASE="dev"

echo "mongodb://${MONGO_USER}:${MONGO_PASSWORD}@$(hostname):27017/${MONGO_DATABASE}"
echo "mongodb://${MONGO_USER}:${MONGO_PASSWORD}@$(hostname):27017/${MONGO_DATABASE}"
echo "mongodb://${MONGO_USER}:${MONGO_PASSWORD}@$(hostname):27017/${MONGO_DATABASE}"
echo "mongodb://${MONGO_USER}:${MONGO_PASSWORD}@$(hostname):27017/${MONGO_DATABASE}"
mongo admin --eval "db.getSiblingDB('admin').runCommand({setParameter: 1, internalQueryExecYieldPeriodMS: 1000});"
mongo admin --eval "db.getSiblingDB('admin').runCommand({setParameter: 1, internalQueryExecYieldIterations: 100000});"
#mongo admin --eval "rs.initiate();"
##mongo admin --eval "rs.add('localhost:27017');"

if [ "$MONGO_ROOT_PASSWORD" ]; then
	mongo admin --eval "db.createUser({user: 'root', pwd: '$MONGO_ROOT_PASSWORD', roles:[{role:'root',db:'admin'}]});"
fi

# FIXME database not exsits
#if [ "$MONGO_PASSWORD" ]; then
#	mongo admin --eval "db.createUser({user: '$MONGO_USER', pwd: '$MONGO_PASSWORD', roles:[{role:'root',db:'$MONGO_DATABASE'}]});"
#fi
touch /data/db/.mongodb_password_set
echo "mongodb://${MONGO_USER}:${MONGO_PASSWORD}@$(hostname):27017/${MONGO_DATABASE}"
tail -f /dev/null
#/tmp/mongodb-27017.sock
#mongod --storageEngine rocksdb --fork --logpath=a.log --port 27018 --dbpath .
