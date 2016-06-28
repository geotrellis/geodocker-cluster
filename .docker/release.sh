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

docker tag geotrellis/geodocker-zookeeper:latest quay.io/geotrellis/geodocker-zookeeper:${TAG}
docker tag geotrellis/geodocker-hadoop:latest quay.io/geotrellis/geodocker-hadoop:${TAG}
docker tag geotrellis/geodocker-accumulo:latest quay.io/geotrellis/geodocker-accumulo:${TAG}
docker tag geotrellis/geodocker-accumulo-gis:latest quay.io/geotrellis/geodocker-accumulo-gis:${TAG}
docker tag geotrellis/geodocker-spark:latest quay.io/geotrellis/geodocker-spark:${TAG}
docker tag geotrellis/geodocker-geoserver:latest quay.io/geotrellis/geodocker-geoserver:${TAG}

if ${PUBLISH}; then
    docker push quay.io/geotrellis/geodocker-zookeeper:${TAG}
    docker push quay.io/geotrellis/geodocker-hadoop:${TAG}
    docker push quay.io/geotrellis/geodocker-accumulo:${TAG}
    docker push quay.io/geotrellis/geodocker-accumulo-gis:${TAG}
    docker push quay.io/geotrellis/geodocker-spark:${TAG}
    docker push quay.io/geotrellis/geodocker-geoserver:${TAG}
fi
