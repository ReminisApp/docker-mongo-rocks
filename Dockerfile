FROM buildpack-deps:stretch

WORKDIR /src

RUN apt-get update && \
    apt-get install -y git zlib1g-dev libbz2-dev libsnappy-dev scons && \
    git clone https://github.com/facebook/rocksdb.git && \
    cd rocksdb && \
    make static_lib && \
    INSTALL_PATH=/usr make install &&\
    cd .. && \
    git clone https://github.com/mongodb/mongo.git && \
    git clone https://github.com/mongodb-partners/mongo-rocks.git && \
    mkdir -p mongo/src/mongo/db/modules/ && \
    ln -sf /src/mongo-rocks mongo/src/mongo/db/modules/rocks && \
    cd mongo && \
    scons
