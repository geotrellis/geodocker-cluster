#!/bin/bash

docker exec -it master1 bash -c ". ~/.bashrc; rm -rf ./geomesa && \
                                 git clone https://github.com/locationtech/geomesa.git; cd ./geomesa && \
                                 git checkout geomesa-1.2.0 && \
                                 mvn clean install -Dmaven.test.skip=true && \
                                 hadoop fs -mkdir -p /accumulo/system-classpath && \
                                 hadoop fs -copyFromLocal geomesa-accumulo/geomesa-accumulo-distributed-runtime/target/geomesa-accumulo-distributed-runtime-1.2.0.jar /accumulo/system-classpath/ && \
                                 hadoop fs -copyFromLocal ~/.m2/repository/joda-time/joda-time/2.3/joda-time-2.3.jar /accumulo/system-classpath/ && cd ../ && \
                                 git clone https://github.com/geomesa/geomesa-tutorials.git; cd ./geomesa-tutorials && \
                                 git checkout e8d9eabba5aa277282e0feb6749c8e9e62296b8a && \
                                 mvn clean install -f geomesa-quickstart-accumulo/pom.xml -Dmaven.test.skip=true"
