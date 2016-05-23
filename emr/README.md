# Amazon EMR Docker Accumulo Bootstrap

Amazon EMR already provides an envrinment with HDFS, Zookeeper, and YARN. This bootstrap script enables us to deploy Apache Accumulo on top of EMR cluster through docker containers. The main adventage of using docker in this scenario is ability to extend the container, for instance by adding GeoWave or GeoMesa iterator jars and still use the same bootstrap scripts.

## Parameters

The script is parametrized on following arguments:

  - `-i | --image` docker image to be used for accumulo
  - `-as | --accumulo-secret` accumulo secret to be used
  - `-ap |--accumulo-password` accumulo password for root account
  - `in | --instance-name` accumulo instance name

These parameters have default values defined at the top of the bootstrap script.

## Usage

In order to use this bootstrap script it should be coppied to an S3 bucket under your control so it accessed by the EMR cluster during the bootstrap phase.
