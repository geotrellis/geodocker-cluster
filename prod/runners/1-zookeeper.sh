#!/bin/bash

for i in "$@"
do
case $i in
    -t=*|--tag=*)
    TAG="${i#*=}"
    shift
    ;;
    -zi=*|--zookeeper-id=*)
    ${ZOOKEEPER_ID}="${i#*=}"
    shift
    ;;
    -zs1=*|--zookeeper-server-1=*)
    ${ZOOKEEPER_SERVER_1}="${i#*=}"
    shift
    ;;   
    -zs2=*|--zookeeper-server-2=*)
    ${ZOOKEEPER_SERVER_2}="${i#*=}"
    shift
    ;;   
    -zs3=*|--zookeeper-server-3=*)
    ${ZOOKEEPER_SERVER_3}="${i#*=}"
    shift
    ;;       
    *)
    ;;
esac
done

docker run \
  --name=zookeeper \
  --net=host \
  --volume=/data/gt/zookeeper:/data/zookeeper \
  --env="ZOOKEEPER_ID=${ZOOKEEPER_ID}" \
  --env="ZOOKEEPER_SERVER_1=${ZOOKEEPER_SERVER_1}" \
  --env="ZOOKEEPER_SERVER_2=${ZOOKEEPER_SERVER_2}" \
  --env="ZOOKEEPER_SERVER_3=${ZOOKEEPER_SERVER_3}" \
  --detach \
  --restart=always \
  daunnc/geodocker-zookeeper:${TAG:-"latest"}

docker run \
  --name=spark-master \
  --net=host \
  --detach \
  --restart=always \
  --env="SPARK_DAEMON_MEMORY=2g" \
  --env="SPARK_SUBMIT_DRIVER_MEMORY=1g" \
  --env="HADOOP_MASTER_ADDRESS=${HADOOP_MASTER_ADDRESS}" \  
  daunnc/geodocker-spark-master:${TAG:-"latest"}
