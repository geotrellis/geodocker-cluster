#!/bin/bash

docker exec -it \
  geodockercluster_geodocker-accumulo-master_1 \
  bash -c "/sbin/load-iterators.sh geomesa $1"

