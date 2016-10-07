#!/usr/bin/env bash
set -e

#MONGO_ROOT_PASSWORD="root"
#MONGO_USER="user"
#MONGO_PASSWORD="password"
#MONGO_DATABASE="dev"

if [ "$MONGO_ROOT_PASSWORD" ]; then
	mongo admin --eval "db.createUser({user: 'root', pwd: '$MONGO_ROOT_PASSWORD', roles:[{role:'root',db:'admin'}]});"
fi
if [ "$MONGO_PASSWORD" ]; then
	mongo admin --eval "db.createUser({user: '$MONGO_USER', pwd: '$MONGO_PASSWORD', roles:[{role:'root',db:'$MONGO_DATABASE'}]});"
fi
touch /data/db/.mongodb_password_set

if [ "${1:0:1}" = '-' ]; then
	set -- mongod "$@" --storageEngine rocks
fi

# allow the container to be started with `--user`
if [ "$1" = 'mongod' -a "$(id -u)" = '0' ]; then
	chown -R mongodb /data/configdb /data/db
	exec gosu mongodb "$BASH_SOURCE" "$@" --storageEngine rocks
fi

if [ "$1" = 'mongod' ]; then
	numa='numactl --interleave=all'
	if $numa true &> /dev/null; then
		set -- $numa "$@" --storageEngine rocks
	fi
fi
