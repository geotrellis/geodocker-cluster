# Two Node.

Provides accumulo configuration files to maintain two ZooKeeper nodes.

## Build Serf

You can build and publish two-node images (master and slave) using `build.sh` script:

```bash
  Options:
    -a=<1.6.4 | 1.7.0> | --accumulo=<1.6.4 | 1.7.0>  Accumulo version [default: 1.7.0]
    -t=<tag> | --tag=<tag>                           Image tag [default: latest].
    -bt=<tag> | --base-tag=<tag>                     Base image tag [default: latest].
    --build-base                                     Build base image if it is not build.
    --publish                                        Push container to dockerhub.
```

# Start cluster

You can start cluster using `./start-cluster.sh` script:

```bash
  Options:
    -n=<n> | --nodes=<n>    Nodes amount [n >= 2].
    -t=<tag> | --tag=<tag>  Image tag to start [default: latest].    
```
