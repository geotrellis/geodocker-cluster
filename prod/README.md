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
* [runners](./runners)
  * Contains runner scripts to simplify cluster startup

## Build and publish a multinode cluster

A more detailed description how to run and to build containers can be found in each image directory.

* Build all images
  * `docker-compose build`

* Publish all images
  * `./.docker/release -t=0.1.0 --publish`

## Run a multinode cluster

Example of starting a multinode cluster on three machines. Node1 (hostname GeoServer1) is a master node, Node2 (hostname GeoServer2) and Node3 (hostname GeoServer3) slave nodes. Zookeeper strats minimum on three nodes.

```bash
## Zookeepers
# Node1
./1-zookeeper.sh -t=0.1.0 -zi=1 -zs1=GeoServer1 -zs2=GeoServer2 -zs3=GeoServer3
# Node2
./1-zookeeper.sh -t=0.1.0 -zi=2 -zs1=GeoServer1 -zs2=GeoServer2 -zs3=GeoServer3
# Node3
./1-zookeeper.sh -t=0.1.0 -zi=3 -zs1=GeoServer1 -zs2=GeoServer2 -zs3=GeoServer3

## Hadoop
# Node1
./1-hadoop-name.sh -t=0.1.0 -hma=GeoServer1
./2-hadoop-sname.sh -t=0.1.0 -hma=GeoServer1
./3-hadoop-data.sh -t=0.1.0 -hma=GeoServer1
# Node2, Node3
./3-hadoop-data.sh -t=0.1.0 -hma=GeoServer1

## Accumulo
# Node1
./1-accumulo-init.sh -t=0.1.0 -hma=GeoServer1 -az="GeoServer1,GeoServer2,GeoServer3" -as=secret -ap=GisPwd -in=gis
./2-accumulo-master.sh -t=0.1.0 -hma=GeoServer1 -az="GeoServer1,GeoServer2,GeoServer3" -as=secret -ap=GisPwd -in=gis
./3-accumulo-tracer.sh -t=0.1.0 -hma=GeoServer1 -az="GeoServer1,GeoServer2,GeoServer3" -as=secret -ap=GisPwd -in=gis
./4-accumulo-gc.sh -t=0.1.0 -hma=GeoServer1 -az="GeoServer1,GeoServer2,GeoServer3" -as=secret -ap=GisPwd -in=gis
./5-accumulo-monitor.sh -t=0.1.0 -hma=GeoServer1 -az="GeoServer1,GeoServer2,GeoServer3" -as=secret -ap=GisPwd -in=gis
# Node2, Node3
./6-accumulo-tserver.sh -t=0.1.0 -hma=GeoServer1 -az="GeoServer1,GeoServer2,GeoServer3" -as=secret -ap=GisPwd -in=gis

## Spark
# Node1
./1-spark-master.sh -t=0.1.0 -hma=GeoServer1
# Node2, Node3
./2-spark-worker.sh -t=0.1.0 -hma=GeoServer1 -sm=GeoServer2
```

## License

* Licensed under the Apache License, Version 2.0: http://www.apache.org/licenses/LICENSE-2.0
