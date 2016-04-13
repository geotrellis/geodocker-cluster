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

sed -i.bak "s/daunnc\/geodocker-base:latest/daunnc\/geodocker-base:${BASE_TAG}/g" DockerfileMaster
sed -i.bak "s/daunnc\/geodocker-base:latest/daunnc\/geodocker-base:${BASE_TAG}/g" DockerfileSlave

if ${BUILD_BASE}; then 
  cd ../base 
  ./build.sh --accumulo=${ACCUMULO_VERSION}
  cd ~-
fi

docker build -t daunnc/geodocker-master:${TAG} --build-arg ACCUMULO_CONFIG=${ACCUMULO_VERSION%.*} --build-arg ACCUMULO_VERSION=${ACCUMULO_VERSION} -f DockerfileMaster .
docker build -t daunnc/geodocker-slave:${TAG} --build-arg ACCUMULO_CONFIG=${ACCUMULO_VERSION%.*} --build-arg ACCUMULO_VERSION=${ACCUMULO_VERSION} -f DockerfileSlave .

if ${PUBLISH}; then
  docker push daunnc/geodocker-master:${TAG}
  docker push daunnc/geodocker-slave:${TAG}  
fi
