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
MONGO_ROOT_PASSWORD=${MONGO_ROOT_PASSWORD:-$(hostname)}
MONGO_USER=${MONGO_USER:-$(hostname)}
MONGO_PASSWORD=${MONGO_PASSWORD:-$(hostname)}
MONGO_DATABASE=${MONGO_DATABASE:-dev}
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
	mongo admin << EOF
db.changeUserPassword("root", "$MONGO_ROOT_PASSWORD")
EOF
fi

# FIXME database not exsits
if [ "$MONGO_PASSWORD" ]; then
    mongo admin << EOF
use $MONGO_DATABASE
db.createUser({user: '$MONGO_USER', pwd: '$MONGO_PASSWORD', roles:[{role:'dbOwner', db:'$MONGO_DATABASE'}]})
EOF
    mongo admin << EOF
db.changeUserPassword("$MONGO_USER", "$MONGO_PASSWORD")
EOF
fi

kill -9 `ps aux | grep "mongod " | awk 'NR==2{print $2}' | cut -d' ' -f1`

touch /data/db/.mongodb_password_set
echo "mongodb://${MONGO_USER}:${MONGO_PASSWORD}@$(hostname):27017/${MONGO_DATABASE}" | tee /data/db/.mongodb_password
exec "$@" --storageEngine rocksdb --auth &
tail -f /dev/null
#/tmp/mongodb-27017.sock
#mongod --storageEngine rocksdb --fork --logpath=a.log --port 27018 --dbpath .
