#! /usr/bin/env bash

set -eo pipefail

if [[ ${WITH_GEO_ITERATORS} ]]; then
  cd ${ACCUMULO_HOME}/lib/ext/ 
  wget geomesa
  wget geomesa
  wget geowave
  cd ~-
fi

exec "$@"
