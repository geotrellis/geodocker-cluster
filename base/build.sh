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
PUBLISH=${PUBLISH:-false}

docker build -t daunnc/geo-base:${TAG} --build-arg ACCUMULO_VERSION=${ACCUMULO_VERSION} . 

if [ ${PUBLISH} ]; then
  docker push daunnc/geo-base:${TAG}
fi
