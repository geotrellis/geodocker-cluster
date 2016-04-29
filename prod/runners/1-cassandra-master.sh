#!/bin/bash

for i in "$@"
do
case $i in
    -t=*|--tag=*)
    TAG="${i#*=}"
    shift
    ;;
    -v=*|--volume=*)
    VOLUME="${i#*=}"
    shift
    ;;
    -cla=*|--cassandra-listen-address=*)
    CASSANDRA_LISTEN_ADDRESS="${i#*=}"
    shift
    ;;  
    *)
    ;;
esac
done

CASSANDRA_LISTEN_ADDRESS=${CASSANDRA_LISTEN_ADDRESS:-"auto"}

docker run \
  --name cassandra-master \
  --net=host \
  --detach \
  --volume=${VOLUME:-"/data/gt/cassandra"}:/var/lib/cassandra \
  --env="CASSANDRA_LISTEN_ADDRESS=${CASSANDRA_LISTEN_ADDRESS}" \
  cassandra:${TAG:-"latest"}
