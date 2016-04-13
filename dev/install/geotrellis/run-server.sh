#!/bin/bash

docker exec -it master1 bash -c ". ~/.bashrc; cd ./geotrellis-chatta-demo/geotrellis && spark-submit --class geotrellis.chatta.Main target/scala-2.10/GeoTrellis-Tutorial-Project-assembly-0.1-SNAPSHOT.jar"
