#!/bin/bash

for i in "$@"
do
case $i in
    -s=*|--scala=*)
    SCALA_VERSION="${i#*=}"
    shift
    ;;
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

docker build -t daunnc/geodocker-base:${TAG} --build-arg SCALA_VERSION=${SCALA_VERSION} --build-arg ACCUMULO_VERSION=${ACCUMULO_VERSION} . 

if ${PUBLISH}; then
  docker push daunnc/geodocker-base:${TAG}
fi
