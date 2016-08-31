# **[NOT MAINTAINED]** GeoDocker Cluster

**Not maintained** repository, project was moved into a separate [GeoDocker](https://github.com/geodocker/) organization account, and splited into separate github repositories, you can find more information in the [main GeoDocker repository](https://github.com/geodocker/geodocker/). However these containers still would be available on [Docker Hub](https://hub.docker.com/r/daunnc/). Consider updating your environment up to actuall GeoDocker version. Any questions can be [asked](https://github.com/geodocker/geodocker/issues) in the new official geodocker repository issues, or our GeoTrellis [gitter channel](https://gitter.im/geotrellis/geotrellis/) where we can try to answer your questions in a real time.

**[NOT MAINTAINED]** Docker containers with prepared environment to run [GeoTrellis](https://github.com/geotrellis/geotrellis), [GeoMesa](https://github.com/locationtech/geomesa), and [GeoWave](https://github.com/ngageoint/geowave).

**[NOT MAINTAINED]** *Current version (latest)*: **0.2.1**

## Migration guide

There is no real differences in container usages, same volumes to mount, similar `docker-compose` usage. In fact the real user difference would be only in images names, in passed cli arguments and env variables. All [prod deployment](https://github.com/geotrellis/geodocker-cluster#run-a-multinode-cluster) steps would be the same, but [runners](./runners) direcotry is deprecated and not maintained as well as it's an obfuscation of `docker` cli usage, follow [GeoDocker](https://github.com/geodocker/geodocker/) repo instructions and updates.

## Environment

* [Hadoop (HDFS + YARN) 2.7.1](https://hadoop.apache.org/)
* [ZooKeeper 3.4.6](https://zookeeper.apache.org/)
* [Accumulo 1.7.1](https://accumulo.apache.org/)
* [Spark 1.6.1 (Scala 2.10)](http://spark.apache.org/)

## Repository short description (index of ReadMe docs)

Images:

* [accumulo 1.7.1](./accumulo) [[dockerhub]](https://hub.docker.com/r/daunnc/geodocker-accumulo/)
* [hadoop 2.7.1](./hadoop) [[dockerhub]](https://hub.docker.com/r/daunnc/geodocker-hadoop/)
* [spark 1.6.1](./spark) [[dockerhub]](https://hub.docker.com/r/daunnc/geodocker-spark/)
* [zookeeper 3.4.6](./zookeeper) [[dockerhub]](https://hub.docker.com/r/daunnc/geodocker-zookeeper/)
* [cassandra](https://hub.docker.com/_/cassandra/)
  * In run scripts used official cassandra image
* [runners](./runners)
  * Contains runner scripts to simplify cluster startup

## Build and publish a multinode cluster

A more detailed description how to run and to build containers can be found in each image directory.

* Build all images
  * `docker-compose build`

* Publish all images
  * `./.docker/release -t=latest --publish`

## Run a multinode cluster

Example of starting a multinode cluster on three machines. Node1 (hostname GeoServer1) is a master node, Node2 (hostname GeoServer2) and Node3 (hostname GeoServer3) slave nodes. Zookeeper strats minimum on three nodes.

```bash
## Zookeepers
# Node1
./1-zookeeper.sh -t=latest -zi=1 -zs1=GeoServer1 -zs2=GeoServer2 -zs3=GeoServer3
# Node2
./1-zookeeper.sh -t=latest -zi=2 -zs1=GeoServer1 -zs2=GeoServer2 -zs3=GeoServer3
# Node3
./1-zookeeper.sh -t=latest -zi=3 -zs1=GeoServer1 -zs2=GeoServer2 -zs3=GeoServer3

## Hadoop
# Node1
./1-hadoop-name.sh -t=latest -hma=GeoServer1
./2-hadoop-sname.sh -t=latest -hma=GeoServer1
./3-hadoop-data.sh -t=latest -hma=GeoServer1
# Node2, Node3
./3-hadoop-data.sh -t=latest -hma=GeoServer1

## Accumulo
# Node1
./1-accumulo-init.sh -t=latest -hma=GeoServer1 -az="GeoServer1,GeoServer2,GeoServer3" -as=secret -ap=GisPwd -in=gis
./2-accumulo-master.sh -t=latest -hma=GeoServer1 -az="GeoServer1,GeoServer2,GeoServer3" -as=secret -ap=GisPwd -in=gis
./3-accumulo-tracer.sh -t=latest -hma=GeoServer1 -az="GeoServer1,GeoServer2,GeoServer3" -as=secret -ap=GisPwd -in=gis
./4-accumulo-gc.sh -t=latest -hma=GeoServer1 -az="GeoServer1,GeoServer2,GeoServer3" -as=secret -ap=GisPwd -in=gis
./5-accumulo-monitor.sh -t=latest -hma=GeoServer1 -az="GeoServer1,GeoServer2,GeoServer3" -as=secret -ap=GisPwd -in=gis
# Node2, Node3
./6-accumulo-tserver.sh -t=latest -hma=GeoServer1 -az="GeoServer1,GeoServer2,GeoServer3" -as=secret -ap=GisPwd -in=gis

## Spark
# Node1
./1-spark-master.sh -t=latest -hma=GeoServer1
# Node2, Node3
./2-spark-worker.sh -t=latest -hma=GeoServer1 -sm=GeoServer1

## Cassandra
# Node1
./1-cassandra-master.sh -t=latest -cla=GeoServer1
# Node2
./2-cassandra-slave.sh -t=latest -cla=GeoServer2 -cs=GeoServer1
# Node3
./2-cassandra-slave.sh -t=latest -cla=GeoServer3 -cs=GeoServer1
```

## Run a local multinode cluster

We can simulate a multinode cluster on a single machine using Docker Compose. [docker-compose-dev.yml](./docker-compose-dev.yml) is an example of instrutions to rise a singlenode cluster, adding additional services description for slave nodes allwos to rise any nodes amount (limited by host machine memory).

```bash
docker-compose -f docker-compose-dev.yml up 
```

## License

* Licensed under the Apache License, Version 2.0: http://www.apache.org/licenses/LICENSE-2.0
