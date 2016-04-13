#!/bin/bash

docker exec -it master1 bash -c ". ~/.bashrc; java -cp ./geomesa-tutorials/geomesa-quickstart-accumulo/target/geomesa-quickstart-accumulo-1.2.1.jar com.example.geomesa.accumulo.AccumuloQuickStart -instanceId gis -zookeepers master1.gt:2181 -user root -password secret -tableName geomesa"
