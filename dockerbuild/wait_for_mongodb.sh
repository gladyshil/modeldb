#!/bin/bash
# wait-for-mongodb.sh

# Usage: sh /modeldb/dockerbuild/wait_for_mongodb.sh 0.10.0 mongo

set -e

thrift_version="$1"
host="$2"

export ROOT_PASSWORD=$(< /mongo/mongodb-root-password)

# 'foo' doesn't matter here. Just needs something so that $host is interpreted
# as a hostname and not a database name.
#--eval "db.getCollectionNames()"

until mongo "$host"/foo -u "root" -p "$ROOT_PASSWORD"  --authenticationDatabase "admin" > /dev/null 2>&1; do
    >&2 echo "MongoDB is unavailable - sleeping"
    sleep 1
done

>&2 echo "MongoDB is up - executing command"

# Substitute the desired MongoDB hostname in the built project's conf file.
before="$PWD"

cd /modeldb/server/codegen
#cp /modeldb/reference.conf target/classes/reference.conf
sed -i "s/MONGODB_HOST/$host/" /modeldb/reference.conf
cd "$before"

USERNAME=$(</mongo/auth/mongodb-username)
PASSWORD=$(</mongo/auth/mongodb-password)


java -Dconfig.file=/modeldb/reference.conf  -jar /modeldb/modeldb.jar


#exec mvn exec:java -Dexec.mainClass='edu.mit.csail.db.ml.main.Main' -Dthrift_version=$thrift_version
