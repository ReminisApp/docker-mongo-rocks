FROM ubuntu:trusty

ENV DEBIAN_FRONTEND noninteractive

WORKDIR /src

RUN apt-get update && \
    apt-get install -y libsasl2-2 curl git && \
    curl -s -O https://www.percona.com/downloads/percona-server-mongodb/percona-server-mongodb-3.0.8-1.2/binary/debian/trusty/x86_64/percona-server-mongodb-3.0.8-1.2-r97f91ef-trusty-x86_64-bundle.tar && \
    tar -xf percona-server-mongodb-3.0.8-1.2-r97f91ef-trusty-x86_64-bundle.tar && \
    dpkg -i percona-server-mongodb-server_3.0.8-1.2.trusty_amd64.deb && \
    dpkg -i percona-server-mongodb-mongos_3.0.8-1.2.trusty_amd64.deb && \
    dpkg -i percona-server-mongodb-tools_3.0.8-1.2.trusty_amd64.deb && \
    dpkg -i percona-server-mongodb-shell_3.0.8-1.2.trusty_amd64.deb && \
    dpkg -i percona-server-mongodb_3.0.8-1.2.trusty_amd64.deb && \
    dpkg -i percona-server-mongodb-dbg_3.0.8-1.2.trusty_amd64.deb

ENV PATH ${PATH}:/usr/local/go/bin
ENV GOPATH /go
RUN curl https://storage.googleapis.com/golang/go1.5.3.linux-amd64.tar.gz | tar xzf - -C /usr/local && \
    echo 'export PATH="/usr/local/go/bin:${PATH}:"; export GOPATH=/go' | tee /etc/profile.d/golong.sh && \
    go get github.com/facebookgo/rocks-strata/strata/cmd/mongo/lreplica_drivers/strata && \
    go install github.com/facebookgo/rocks-strata/strata/cmd/mongo/lreplica_drivers/strata && \
    rm -fr /src/*

VOLUME /data/db /data/configdb

RUN groupadd -r mongodb && useradd -r -g mongodb mongodb

ENV GOSU_VERSION 1.7

RUN set -x \
    && apt-get install -y gnupg wget numactl \
    && wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture)" \
    && wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture).asc" \
    && export GNUPGHOME="$(mktemp -d)" \
    && gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
    && gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu \
    && rm -r "$GNUPGHOME" /usr/local/bin/gosu.asc \
    && chmod +x /usr/local/bin/gosu \
    && gosu nobody true \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

ENV MONGO_DATABASE dev
ADD docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]

EXPOSE 27017
CMD ["mongod"]
