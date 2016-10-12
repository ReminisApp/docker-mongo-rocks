# docker mongo with rocksdb

[![Docker Pulls](https://img.shields.io/docker/pulls/yongjhih/mongo-rocks.svg)](https://hub.docker.com/r/yongjhih/mongo-rocks/)
[![Docker Stars](https://img.shields.io/docker/stars/yongjhih/mongo-rocks.svg)](https://hub.docker.com/r/yongjhih/mongo-rocks/)
[![Docker Tag](https://img.shields.io/github/tag/yongjhih/docker-mongo-rocks.svg)](https://hub.docker.com/r/yongjhih/mongo-rocks/tags/)
<!--
[![License](https://img.shields.io/github/license/yongjhih/docker-mongo-rocks.svg)](https://github.com/yongjhih/docker-mongo-rocks/raw/master/LICENSE.txt)
[![Travis CI](https://img.shields.io/travis/yongjhih/docker-mongo-rocks.svg)](https://travis-ci.org/yongjhih/docker-mongo-rocks)
[![Gitter Chat](https://img.shields.io/gitter/room/yongjhih/docker-mongo-rocks.svg)](https://gitter.im/yongjhih/docker-mongo-rocks)
-->

## Usage

```
docker run -it yongjhih/mongo-rocks
```

```
docker run -it yongjhih/mongo-rocks --smallfiles --setParameter failIndexKeyTooLong=false
```

## refs

* [facebook/rocksdb](https://github.com/facebook/rocksdb)
* [mongodb-partners/mongo-rocks](https://github.com/mongodb-partners/mongo-rocks)
* [mongo](https://github.com/mongodb/mongo)
* https://github.com/structuresound/docker-mongo-rocks
* https://github.com/jadsonlourenco/docker-mongo-rocks
* https://github.com/docker-library/mongo
* http://blog.parse.com/announcements/mongodb-rocksdb-parse/
* http://blog.parse.com/learn/engineering/migrating-your-parse-app-to-mongorocks/
