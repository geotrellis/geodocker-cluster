# Base

Base image with Hadoop 2.7.1, ZooKeeper 3.6.2, Accumulo (1.6.x | 1.7.x), Spark 1.5.2

## Build Base

You can build and publish base image using `build.sh` script:

```bash
  Options:
    -a=<1.6.x | 1.7.x> | --accumulo=<1.6.x | 1.7.x>  Accumulo version [default: 1.7.1]
    -t=<tag> | --tag=<tag>                           Image tag [default: latest].
    -s=<scala> | --scala=<scala>                     Scala version [default: 2.10].
    --publish                                        Push container to dockerhub.
```
