# GeoDocker Cluster

Docker containers with prepared environment to run [GeoTrellis](https://github.com/geotrellis/geotrellis), [GeoMesa](https://github.com/locationtech/geomesa), and [GeoWave](https://github.com/ngageoint/geowave).

## Environment

* [Hadoop (HDFS + YARN) 2.7.1](https://hadoop.apache.org/)
* [ZooKeeper 3.4.6](https://zookeeper.apache.org/)
* [Accumulo 1.7.1](https://accumulo.apache.org/)
* [Spark 1.5.2 (Scala 2.10 / Scala 2.11)](http://spark.apache.org/)

## Repository short description (index of ReadMe docs)

Base images:

* [accumulo](./accumulo)
  * Contains Accumulo 1.7.1 images: 
    * [base](./accumulo/base) 
    * [gc](./accumulo/gc)
    * [master](./accumulo/master)
    * [monitor](./accumulo/monitor)
    * [tracer](./accumulo/tracer)
    * [tserver](./accumulo/tserver)
* [hadoop](./hadoop)
  * Contains Hadoop 2.7.1 images:
    * [base](./hadoop/base) 
    * [data](./hadoop/data)
    * [name](./hadoop/name)
    * [sname](./hadoop/sname)
* [spark](./spark)
  * Contains Spark 1.5.2 (Scala 2.10 by default) images:
    * [base](./spark/base) 
    * [master](./spark/master)
    * [worker](./spark/worker)
* [zookeeper](./zookeeper)
  * Contains Zookeeper 3.4.6 image    

## Build and publish a multinode cluster

A more detailed description how to run and to build containers can be found in each image directory.

* Build all images
  * `docker-compose build`

* Publish all images
  * `./.docker/release -t=0.1.0 --publish`

## Run a multinode cluster

TODO...

## License

* Based on a repository: https://github.com/alvinhenrick/hadoop-mutinode
* Licensed under the Apache License, Version 2.0: http://www.apache.org/licenses/LICENSE-2.0
