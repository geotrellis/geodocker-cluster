#! /usr/bin/env bash

set -eo pipefail

if [ ${WITH_GEO_ITERATORS} ]; then
  cd ${ACCUMULO_HOME}/lib/ext/ 
  wget https://bitbucket.org/pomadchin/binary/raw/c5b0ea0aa98de751f56848d9915a9b6a4ee8f3df/geo/geomesa-accumulo-distributed-runtime-1.2.1.jar
  wget https://bitbucket.org/pomadchin/binary/raw/c5b0ea0aa98de751f56848d9915a9b6a4ee8f3df/geo/joda-time-2.3.jar
  wget https://bitbucket.org/pomadchin/binary/raw/c5b0ea0aa98de751f56848d9915a9b6a4ee8f3df/geo/geowave-deploy-0.9.1-SNAPSHOT-accumulo-singlejar.jar
  cd ~-
fi

exec "$@"
