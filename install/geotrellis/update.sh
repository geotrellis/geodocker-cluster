#!/bin/bash

docker exec -it master1 bash -c ". ~/.bashrc && \
                                  cd ./geotrellis && git pull && \
                                  ./publish-local.sh && cd ../geotrellis-chatta-demo && \
                                  git pull && cd ./geotrellis-chatta-demo/geotrellis && \
                                  ./sbt assembly"
                                  