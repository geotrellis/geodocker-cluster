# Base

Base image with Hadoop 2.7.1, ZooKeeper 3.6.2, Accumulo (1.6.4 | 1.7.0), Spark 1.5.2

## Build Base

You can build and publish base image using `build.sh` script:

```bash
  Options:
    -a=<1.6.4 | 1.7.0> | --accumulo=<1.6.4 | 1.7.0>  Accumulo version [default: 1.7.0]
    -t=<tag> | --tag=<tag>                           Image tag [default: latest].
    --publish                                        Push container to dockerhub.
```
