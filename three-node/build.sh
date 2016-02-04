#!/bin/bash

for i in "$@"
do
case $i in
    -a=*|--accumulo=*)
    ACCUMULO_VERSION="${i#*=}"
    shift
    ;;
    -t=*|--tag=*)
    TAG="${i#*=}"
    shift
    ;;
    -bt=*|--base-tag=*)
    BASE_TAG="${i#*=}"
    shift
    ;;
    --build-base*)
    BUILD_BASE=true
    shift
    ;;
    --publish*)
    PUBLISH=true
    shift 
    ;;
    *)          
    ;;
esac
done

ACCUMULO_VERSION=${ACCUMULO_VERSION:-1.7.0}
TAG=${TAG:-latest}
BASE_TAG=${BASE_TAG:-latest}
BUILD_BASE=${BUILD_BASE:-false}
PUBLISH=${PUBLISH:-false}

rm -f DockerfileMaster && git checkout DockerfileMaster
sed "s/daunnc\/geo-base:latest/daunnc\/geo-base:${BASE_TAG}/g" DockerfileMaster > DockerfileMaster.new
rm -f DockerfileMaster && mv DockerfileMaster.new DockerfileMaster

rm -f DockerfileSlave && git checkout DockerfileSlave
sed "s/daunnc\/geo-base:latest/daunnc\/geo-base:${BASE_TAG}/g" DockerfileSlave > DockerfileSlave.new
rm -f DockerfileSlave && mv DockerfileSlave.new DockerfileSlave

if ${BUILD_BASE}; then 
  cd ../base 
  ./build.sh --accumulo=${ACCUMULO_VERSION}
  cd ~-
fi

docker build -t daunnc/geo-master-thn:${TAG} --build-arg ACCUMULO_VERSION=${ACCUMULO_VERSION} -f DockerfileMaster .
docker build -t daunnc/geo-slave-thn:${TAG} --build-arg ACCUMULO_VERSION=${ACCUMULO_VERSION} -f DockerfileSlave .

if ${PUBLISH}; then
  docker push daunnc/geo-master-thn:${TAG}  
  docker push daunnc/geo-slave-thn:${TAG}  
fi
