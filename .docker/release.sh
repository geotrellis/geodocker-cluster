#!/bin/sh

for i in "$@"
do
case $i in
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

TAG=${TAG:-latest}
PUBLISH=${PUBLISH:-false}

docker tag daunnc/geodocker-zookeeper:latest daunnc/geodocker-zookeeper:${TAG}
docker tag daunnc/geodocker-hadoop:latest daunnc/geodocker-hadoop:${TAG}
docker tag daunnc/geodocker-accumulo:latest daunnc/geodocker-accumulo:${TAG}
docker tag daunnc/geodocker-accumulo:latest daunnc/geodocker-accumulo-gis:${TAG}
docker tag daunnc/geodocker-spark:latest daunnc/geodocker-spark:${TAG}
docker tag daunnc/geodocker-spark:latest daunnc/geodocker-geoserver:${TAG}

if ${PUBLISH}; then
  docker push daunnc/geodocker-zookeeper:${TAG}
  docker push daunnc/geodocker-hadoop:${TAG}
  docker push daunnc/geodocker-accumulo:${TAG}
  docker push daunnc/geodocker-accumulo-gis:${TAG}
  docker push daunnc/geodocker-spark:${TAG}
  docker push daunnc/geodocker-geoserver:${TAG}
fi
  