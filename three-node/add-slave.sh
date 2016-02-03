#!/bin/bash

for i in "$@"
do
case $i in    
    -t=*|--tag=*)
    TAG="${i#*=}"
    shift
    ;;
    -n=*|--name=*)
    NAME="${i#*=}"
    shift
    ;;
    -h=*|--host=*)
    HOSTNAME="${i#*=}"
    shift
    ;;
    *)
    ;;
esac
done

TAG=${TAG:-latest}

FIRST_IP=$(docker inspect --format="{{.NetworkSettings.IPAddress}}" slave1)

docker run -d -t --dns 127.0.0.1 \
           -e NODE_TYPE=sd \
           -e ZOOKEEPER_ID=4 \
           -e JOIN_IP=$FIRST_IP \
           -e HOSTNAME=$HOSTNAME --name $NAME -h $HOSTNAME daunnc/geo-slave-thn:${TAG}
