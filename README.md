# docker mongo with rocksdb

## Usage

```
docker run -it yongjhih/mongo-rocks
```

```
docker run -it yongjhih/mongo-rocks --smallfiles --setParameter failIndexKeyTooLong=false
```

```
docker run -it -e MONGO_ROOT_PASSWORD=password -e MONGO_USER=user -e MONGO_PASSWORD=password -e MONGO_DATABASE=dev yongjhih/mongo-rocks --auth
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
