# Serf

Serf image is a base image for all other containers, it is based on Ubuntu 14.04 image with [serf](https://www.serfdom.io/) installed.

## Build Serf

You can build and publish serf image using `build.sh` script:

```bash
  Options:
    -t=<tag> | --tag=<tag>  Image tag [default: latest].
    --publish               Push container to dockerhub.
```
