#!/bin/bash

for i in "$@"
do
case $i in    
    -t=*|--tag=*)
    TAG="${i#*=}"
    shift
    ;;
    -n=*|--nodes=*)
    NODES="${i#*=}"
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
NODES=${NODES:-2}

docker run ${VOLUME} -d -t --dns 127.0.0.1 \
           -e NODE_TYPE=s \
           -e ZOOKEEPER_ID=2 --name slave1 -h slave1.gt daunnc/geo-slave-twn:${TAG}

FIRST_IP=$(docker inspect --format="{{.NetworkSettings.IPAddress}}" slave1)

docker run ${VOLUME} -d -t --dns 127.0.0.1 \
           -e NODE_TYPE=m \
           -e ZOOKEEPER_ID=1 \
           -e JOIN_IP=${FIRST_IP} \
           -p 9000:9000 -p 50010:50010 \
           -p 50020:50020 -p 50070:50070 \
           -p 50075:50075 -p 50090:50090 \
           -p 50475:50475 -p 8030:8030 \
           -p 8031:8031 -p 8032:8032 \
           -p 8033:8033 -p 8040:8040 \
           -p 8042:8042 -p 8060:8060 \
           -p 8088:8088 -p 50060:50060 \
           -p 2181:2181 -p 2888:2888 \
           -p 3888:3888 -p 9999:9999 \
           -p 9997:9997 -p 50091:50091 \
           -p 50095:50095 -p 4560:4560 \
           -p 12234:12234 -p 8080:8080 \
           -p 8081:8081 -p 7077:7077 \
           -p 4040:4040 -p 4041:4041 \
           -p 1808:1808 -p 8777:8777 --name master1 -h master1.gt daunnc/geo-master-twn:${TAG}

COUNTER=2

if [ ${NODES} -gt ${COUNTER} ]; then
  sleep 20
fi

while [  ${COUNTER} -lt ${NODES} ]; do
  docker run ${VOLUME} -d -t --dns 127.0.0.1 \
             -e NODE_TYPE=sd \
             -e JOIN_IP=$FIRST_IP \
             -e HOSTNAME="slave${COUNTER}.gt" --name "slave${COUNTER}" -h "slave${COUNTER}.gt" daunnc/geo-slave-twn:${TAG}

  let COUNTER=COUNTER+1 
done