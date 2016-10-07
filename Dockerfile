FROM buildpack-deps:stretch

RUN groupadd -r mongodb && useradd -r -g mongodb mongodb

WORKDIR /src

RUN apt-get update && \
    apt-get install -y git zlib1g-dev libbz2-dev libsnappy-dev scons numactl gpg && \
    rm -rf /var/lib/apt/lists/*

ENV GOSU_VERSION 1.7

RUN set -x \
    && wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture)" \
    && wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture).asc" \
    && export GNUPGHOME="$(mktemp -d)" \
    && gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
    && gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu \
    && rm -r "$GNUPGHOME" /usr/local/bin/gosu.asc \
    && chmod +x /usr/local/bin/gosu \
    && gosu nobody true && \
    mkdir -p /data/db /data/configdb \
    && chown -R mongodb:mongodb /data/db /data/configdb

RUN git clone https://github.com/facebook/rocksdb.git && \
    cd rocksdb && \
    make static_lib && \
    INSTALL_PATH=/usr make install && \
    cd ..

RUN git clone https://github.com/mongodb/mongo.git && \
    git clone https://github.com/mongodb-partners/mongo-rocks.git && \
    mkdir -p mongo/src/mongo/db/modules/ && \
    ln -sf /src/mongo-rocks mongo/src/mongo/db/modules/rocks && \
    cd mongo && \
    scons

VOLUME /data/db /data/configdb
ADD docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]

EXPOSE 27017
CMD ["mongod"]
