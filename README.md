# GeoDocker Cluster

Docker containers with prepared environment to run [GeoTrellis](https://github.com/geotrellis/geotrellis), [GeoMesa](https://github.com/locationtech/geomesa), and [GeoWave](https://github.com/ngageoint/geowave) jobs. These images will create a set of containers, running in a distributed fashion, *on a single machine*. In practice, this requires being careful to ensure that enough memory is available for all images.

## Environment

* [Hadoop (HDFS + YARN) 2.7.1](https://hadoop.apache.org/)
* [ZooKeeper 3.4.6](https://zookeeper.apache.org/)
* [Accumulo 1.6.4 / 1.7.0](https://accumulo.apache.org/) (the specific version to use is configurable)
* [Spark 1.5.2](http://spark.apache.org/)

## Repository short description (index of ReadMe docs)

Base images:

* [base image](./base)
  * Contains a Dockerfile to build an image with Hadoop, ZooKeeper, Accumulo and Spark installed (but not configured).
  * Available on [Dockerhub](https://hub.docker.com/): 
    * [geo-base](https://hub.docker.com/r/daunnc/geo-base/)

* [serf image](./serf)
  * Contains a Dockerfile to build an Ubuntu 14.04 image with [serf](https://www.serfdom.io/).
  * Available on [Dockerhub](https://hub.docker.com/): 
    * [serf](https://hub.docker.com/r/daunnc/serf/)

Concrete images:
Note: It is possible to have a multinode (n-node) cluster with any number of Zookeeper instances.

* [single-node image](./single-node)
  * Contains a ZooKeeper node, working in a singlenode mode. 
  * Available on [Dockerhub](https://hub.docker.com/): 
    * [geo-master-sn](https://hub.docker.com/r/daunnc/geo-master-sn/)
    * [geo-slave-sn](https://hub.docker.com/r/daunnc/geo-slave-sn/)

* [two-node image](./two-node)
  * Available on [Dockerhub](https://hub.docker.com/): 
    * [geo-master-twn](https://hub.docker.com/r/daunnc/geo-master-twn/)
    * [geo-slave-twn](https://hub.docker.com/r/daunnc/geo-slave-twn/)

* [three-node image](./three-node)
  * Available on [Dockerhub](https://hub.docker.com/): 
    * [geo-master-thn](https://hub.docker.com/r/daunnc/geo-master-thn/)
    * [geo-slave-thn](https://hub.docker.com/r/daunnc/geo-slave-thn/)

[GeoTrellis](https://github.com/geotrellis/geotrellis), [GeoMesa](https://github.com/locationtech/geomesa), and [GeoWave](https://github.com/ngageoint/geowave/): 

* [install directory](./install)
  * Contains scripts to install [GeoTrellis](https://github.com/geotrellis/geotrellis), [GeoMesa](https://github.com/locationtech/geomesa) and [GeoWave](https://github.com/ngageoint/geowave) into cluster and to run test examples, to be sure that cluster and library operating correct.

## Build a multinode cluster

A more detailed description how to run and to build containers can be found in each image directory.

* Build serf container
  * `cd serf; ./build.sh`

* Build base container
  * `cd base; ./build.sh`

* Build n-node master and slave containers
  * `cd n-node; ./build.sh`

**Sart the n-container cluster.**

 * `cd n-node; ./start-cluster.sh --nodes=nn # nn >= n`

## Probable issues and solutions

A possible use case, is to have possibility to access cluster outside the docker cluster. The probable issue can happen, trying to run some `Accumulo` related jobs where we have to provide a `ZooKeeper` node(s) address.

```bash
WARN impl.ServerClient: Failed to find an available server 
in the list of servers: [master1.gt:9997 (120000), slave1.gt:9997 (120000)]
```

The cause of the problem, that inside docker cluster used own dns, so the client machine where this error happened has no dns records for `master1.gt` hostname. The solution is to provide it manually (as a variant just to add it into the `/etc/hosts` file).

## License

* Based on a repository: https://github.com/alvinhenrick/hadoop-mutinode
* Licensed under the Apache License, Version 2.0: http://www.apache.org/licenses/LICENSE-2.0
