#!/bin/bash

for i in "$@"
do
case $i in
    -t=*|--tag=*)
    TAG="${i#*=}"
    shift
    ;;
    -hma=*|--hadoop-master-address=*)
    HADOOP_MASTER_ADDRESS="${i#*=}"
    shift
    ;;
    -az=*|--accumulo-zookeepers=*)
    ACCUMULO_ZOOKEEPERS="${i#*=}"
    shift
    ;;
    -as=*|--accumulo-secret=*)
    ACCUMULO_SECRET="${i#*=}"
    shift
    ;;
    -ap=*|--accumulo-password=*)
    ACCUMULO_PASSWORD="${i#*=}"
    shift
    ;;
    -in=*|--instance-name=*)
    INSTANCE_NAME="${i#*=}"
    shift
    ;;
    *)
    ;;
esac
done

docker run \
  --name=accumulo-master \
  --net=host \
  --detach \
  --restart=always \
  --env="HADOOP_MASTER_ADDRESS=${HADOOP_MASTER_ADDRESS}" \
  --env="ACCUMULO_ZOOKEEPERS=${ACCUMULO_ZOOKEEPERS}" \
  --env="ACCUMULO_SECRET=${ACCUMULO_SECRET}" \
  --env="ACCUMULO_PASSWORD=${ACCUMULO_PASSWORD}" \
  daunnc/geodocker-accumulo-master:${TAG:-"latest"} \
  accumulo init --instance-name ${INSTANCE_NAME} --password ${ACCUMULO_PASSWORD}
