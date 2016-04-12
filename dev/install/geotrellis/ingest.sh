#!/bin/bash

docker exec -it master1 bash -c ". ~/.bashrc; cd ./geotrellis-chatta-demo/geotrellis && ./ingest.sh"
