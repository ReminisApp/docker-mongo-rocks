FROM ubuntu:trusty

WORKDIR /src

RUN apt-get update && \
    apt-get install -y curl golang && \
    curl -s -O https://www.percona.com/downloads/percona-server-mongodb/percona-server-mongodb-3.0.8-1.2/binary/debian/trusty/x86_64/percona-server-mongodb-3.0.8-1.2-r97f91ef-trusty-x86_64-bundle.tar && \
    tar -xf percona-server-mongodb-3.0.8-1.2-r97f91ef-trusty-x86_64-bundle.tar && \
    dpkg -i percona-server-mongodb-* && \
    go get github.com/facebookgo/rocks-strata/strata/cmd/mongo/lreplica_s3storage_driver/strata && \
    go install github.com/facebookgo/rocks-strata/strata/cmd/mongo/lreplica_s3storage_driver/strata

#    curl https://storage.googleapis.com/golang/go1.5.3.linux-amd64.tar.gz | tar xzf - -C /usr/local
#    mkdir /go
#    chmod 0777 /go

VOLUME /data/db /data/configdb

ENV MONGO_DATABASE dev
ADD docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]

EXPOSE 27017
CMD ["mongod"]
