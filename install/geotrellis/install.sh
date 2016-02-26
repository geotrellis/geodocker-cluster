#!/bin/bash

for i in "$@"
do
case $i in
    -s=*|--scala=*)
    SCALA_VERSION="${i#*=}"
    shift 
    ;;    
    *)
    ;;
esac
done

SCALA_VERSION=${SCALA_VERSION:-"2.10.5"}

docker exec -it master1 bash -c ". ~/.bashrc && \
                                  rm -rf geotrellis; git clone https://github.com/geotrellis/geotrellis.git && \
                                  cd ./geotrellis; ./scripts/publish-local.sh; cd ../ && \
                                  rm -rf geotrellis-chatta-demo; git clone https://github.com/pomadchin/geotrellis-chatta-demo.git && \
                                  cd ./geotrellis-chatta-demo/geotrellis; git checkout spark-version; ./sbt -Dscala.version=${SCALA_VERSION} assembly"

docker cp fs/resources master1:/data/geotrellis-chatta-demo/geotrellis/src/main/
docker cp fs/ingest.sh master1:/data/geotrellis-chatta-demo/geotrellis/
