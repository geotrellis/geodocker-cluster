#!/bin/bash

for i in "$@"
do
case $i in
    -t=*|--tag=*)
    TAG="${i#*=}"
    shift
    ;;
    -hma=*|--hadoop-master-address=*)
    ${HADOOP_MASTER_ADDRESS}="${i#*=}"
    shift
    ;;    
    *)
    ;;
esac
done

docker run \
  --name=hadoop-data \
  --net=host \
  --volume=/data/gt/hdfs:/data/hdfs \
  --detach \
  --restart=always \
  --env="HADOOP_MASTER_ADDRESS=${HADOOP_MASTER_ADDRESS}" \  
  daunnc/geodocker-hadoop-data:${TAG:-"latest"}
