# GeoDocker Cluster

Docker containers with prepared environment to run [GeoTrellis](https://github.com/geotrellis/geotrellis), [GeoMesa](https://github.com/locationtech/geomesa), and [GeoWave](https://github.com/ngageoint/geowave) jobs. These images will create a set of containers, running in a distributed fashion, *on a single machine*. In practice, this requires being careful to ensure that enough memory is available for all images.

## Environment

* [Hadoop (HDFS + YARN) 2.7.1](https://hadoop.apache.org/)
* [ZooKeeper 3.4.6](https://zookeeper.apache.org/)
* [Accumulo 1.6.x / 1.7.x](https://accumulo.apache.org/) (the specific version to use is configurable)
* [Spark 1.5.2 (Scala 2.10 / Scala 2.11)](http://spark.apache.org/)

## Repository short description (index of ReadMe docs)

Base images:

* [base image](./base)
  * Contains a Dockerfile to build an image with Hadoop, ZooKeeper, Accumulo and Spark installed (but not configured).
  * Available on [Dockerhub](https://hub.docker.com/): 
    * [geodocker-base](https://hub.docker.com/r/daunnc/geodocker-base/)

* [serf image](./serf)
  * Contains a Dockerfile to build an Ubuntu 14.04 image with [serf](https://www.serfdom.io/).
  * Available on [Dockerhub](https://hub.docker.com/): 
    * [serf](https://hub.docker.com/r/daunnc/serf/)

* [nodes](./nodes)
  * Contains a cluster with a ZooKeeper node, working in a singlenode mode. 
  * Available on [Dockerhub](https://hub.docker.com/): 
    * [geodocker-master](https://hub.docker.com/r/daunnc/geodocker-master/)
    * [geodocker-slave](https://hub.docker.com/r/daunnc/geodocker-slave/)
* Dockerhub images tags description:
  * 0.1.0 - contains [Accumulo 1.6.5](https://accumulo.apache.org/) and [Spark 1.5.2 (Scala 2.10)](http://spark.apache.org/)
  * 0.1.1 - contains [Accumulo 1.6.5](https://accumulo.apache.org/) and [Spark 1.5.2 (Scala 2.11)](http://spark.apache.org/)
  * 0.2.0 - contains [Accumulo 1.7.0](https://accumulo.apache.org/) and [Spark 1.5.2 (Scala 2.10)](http://spark.apache.org/)
  * 0.2.1 - contains [Accumulo 1.7.0](https://accumulo.apache.org/) and [Spark 1.5.2 (Scala 2.11)](http://spark.apache.org/)
  * latest - contains [Accumulo 1.7.0](https://accumulo.apache.org/) and [Spark 1.5.2 (Scala 2.10)](http://spark.apache.org/)

[GeoTrellis](https://github.com/geotrellis/geotrellis), [GeoMesa](https://github.com/locationtech/geomesa), and [GeoWave](https://github.com/ngageoint/geowave/): 

* [install directory](./install)
  * Contains scripts to install [GeoTrellis](https://github.com/geotrellis/geotrellis), [GeoMesa](https://github.com/locationtech/geomesa) and [GeoWave](https://github.com/ngageoint/geowave) into cluster and to run test examples, to be sure that cluster and library operating correct.

## Build a multinode cluster

A more detailed description how to run and to build containers can be found in each image directory.

* Build serf container
  * `cd serf; ./build.sh`

* Build base container
  * `cd base; ./build.sh`

* Build master and slave containers
  * `cd nodes; ./build.sh`

**Sart the n-node cluster.**

 * `cd nodes; ./start-cluster.sh --nodes=n # n >= 1`

## Probable issues and solutions

A possible use case, is to have possibility to access cluster outside the GeoDocker Cluster (on a separate machine or on a host machine). The probable issue can happen, trying to run some `Accumulo` related jobs where we have to provide a `ZooKeeper` node address.

```bash
WARN impl.ServerClient: Failed to find an available server 
in the list of servers: [master1.gt:9997 (120000), slave1.gt:9997 (120000)]
```

The cause of the problem, that inside docker cluster used own dns, so the client machine where this error happened has no dns records for `master1.gt` hostname. The solution is to provide it manually (as a variant just to add it into the `/etc/hosts` file).

## License

* Based on a repository: https://github.com/alvinhenrick/hadoop-mutinode
* Licensed under the Apache License, Version 2.0: http://www.apache.org/licenses/LICENSE-2.0
