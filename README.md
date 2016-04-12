# GeoDocker Cluster

Docker containers with prepared environment to run [GeoTrellis](https://github.com/geotrellis/geotrellis), [GeoMesa](https://github.com/locationtech/geomesa), and [GeoWave](https://github.com/ngageoint/geowave) jobs. 
[Dev](./dev) images will create a set of containers, running in a distributed fashion, *on a single machine*. In practice, this requires being careful to ensure that enough memory is available for all images. [Prod](./prod) images preapared to to run a real docker cluster.

## Environment

* [Hadoop (HDFS + YARN) 2.7.1](https://hadoop.apache.org/)
* [ZooKeeper 3.4.6](https://zookeeper.apache.org/)
* [Accumulo 1.6.x / 1.7.x](https://accumulo.apache.org/)
* [Spark 1.5.2 (Scala 2.10 / Scala 2.11)](http://spark.apache.org/)

## License

* Licensed under the Apache License, Version 2.0: http://www.apache.org/licenses/LICENSE-2.0
