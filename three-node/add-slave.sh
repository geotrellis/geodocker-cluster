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
    HOST_NAME="${i#*=}"
    shift
    ;;
    -v=*|--volume=*)
    VOLUME="-v ${i#*=}:/data"
    shift
    ;;
    *)
    ;;
esac
done

TAG=${TAG:-latest}

FIRST_IP=$(docker inspect --format="{{.NetworkSettings.IPAddress}}" slave1)

docker run ${VOLUME} -d -t --dns 127.0.0.1 \
             -e NODE_TYPE=sd \
             -e JOIN_IP=${FIRST_IP} \
             -e HOSTNAME=${HOST_NAME} --name ${NAME} -h ${HOST_NAME} daunnc/geo-slave-sn:${TAG}