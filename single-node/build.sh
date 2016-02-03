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
    TAG="${i#*=}"
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

if ${BUILD_BASE}; then 
  cd ../base 
  ./build.sh --accumulo=${ACCUMULO_VERSION}
  cd ~-
fi

docker build -t daunnc/geo-master-sn:${TAG} --build-arg ACCUMULO_VERSION=${ACCUMULO_VERSION} -f DockerfileMaster .

if ${PUBLISH}; then
  docker push daunnc/geo-master-sn:${TAG}  
fi
