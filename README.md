# Docker Geo environment.

Docker containers with prepeared environment to run [GeoTrellis](https://github.com/geotrellis/geotrellis), [GeoMesa](https://github.com/geotrellis/geotrellis) and [GeoWave](https://github.com/ngageoint/geowave/) jobs.
As the result, there would be a set of containers on a single machine in a distributed mode, so for heavy jobs there should be enough ram.

## Environment

* [Hadoop (HDFS + YARN) 2.7.1](https://hadoop.apache.org/)
* [ZooKeeper 3.4.6](https://zookeeper.apache.org/)
* [Accumulo 1.6.4 / 1.7.0](https://accumulo.apache.org/) (it is possible to select one of these versions)
* [Spark 1.5.2](http://spark.apache.org/)

## Repository short description (index of ReadMe docs)

Base images:

* [serf image](./serf)
  * Contains a Dockerfile to build an Ubuntu 14.04 image with [srerf](https://www.serfdom.io/).
  * Available on [Dockerhub](https://hub.docker.com/): 
    * [serf](https://hub.docker.com/r/daunnc/serf/)

* [base image](./base)
  * Contains a Dockerfile to build an image with installed Hadoop, ZooKeeper, Accumulo and Spark but not configured.
  * Available on [Dockerhub](https://hub.docker.com/): 
    * [geo-base](https://hub.docker.com/r/daunnc/geo-base/)

Nodes images:

* [single-node image](./single-node)
  * Contains a ZooKeeper node, working in a singlenode mode, but it is possible to have multinode (n-node, n >= 1) cluster with one ZooKeeper.
  * Available on [Dockerhub](https://hub.docker.com/): 
    * [geo-master-sn](https://hub.docker.com/r/daunnc/geo-master-sn/)
    * [geo-slave-sn](https://hub.docker.com/r/daunnc/geo-slave-sn/)

* [two-node image](./two-node)
  * Contains two ZooKeeper nodes, it is possible to have multinode (n-node, n >= 2) cluster with two ZooKeepers.
  * Available on [Dockerhub](https://hub.docker.com/): 
    * [geo-master-twn](https://hub.docker.com/r/daunnc/geo-master-twn/)
    * [geo-slave-twn](https://hub.docker.com/r/daunnc/geo-slave-twn/)

* [three-node image](./three-node)
  * Contains three ZooKeeper nodes, it is possible to have multinode (n-node, n >= 3) cluster with three ZooKeepers.
  * Available on [Dockerhub](https://hub.docker.com/): 
    * [geo-master-thn](https://hub.docker.com/r/daunnc/geo-master-thn/)
    * [geo-slave-thn](https://hub.docker.com/r/daunnc/geo-slave-thn/)

[GeoTrellis](https://github.com/geotrellis/geotrellis), [GeoMesa](https://github.com/geotrellis/geotrellis) and [GeoWave](https://github.com/ngageoint/geowave/): 

* [install directory](./install)
  * Contains scripts to install [GeoTrellis](https://github.com/geotrellis/geotrellis), [GeoMesa](https://github.com/geotrellis/geotrellis) and [GeoWave](https://github.com/ngageoint/geowave/) into cluster and to run test examples, to be sure that cluster and library operating correct.

## Build a multinode cluster

A more detailed description how to run and to build containers can be found in each image directory.

* Build serf container
  * `cd serf; ./build.sh`

* Build base container
  * `cd base; ./build.sh`

* Build n-node master and slave containers
  * `cd n-node; ./build.sh`

**Sart the n container cluster.**

 * `cd n-node; ./start-cluster.sh --nodes=nn # nn >= n`
     
## License

* Based on a repository: https://github.com/alvinhenrick/hadoop-mutinode
* Licensed under the Apache License, Version 2.0: http://www.apache.org/licenses/LICENSE-2.0