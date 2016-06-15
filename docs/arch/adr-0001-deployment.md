0001 - GeoDocker deployment
===============================

Context
-------
We have working docker environment, and it is possible to strat it destributed, on different machines, manually. The problem of this docker environment, that there is no proper way to deploy it and to scale. The solution should be available not only for services with _rich api_ (like AWS or DigitalOcean) but also for common hosting providers, however the last citeria in not the most important thing currently.

Decision
--------
Was decided to look at popular docker orchestration tools:
  * [ECS](http://docs.aws.amazon.com/AmazonECS/latest/developerguide/Welcome.html)
  * [DCOS](http://dcos.io)
  * [Rancher](http://rancher.com)

##### ECS

ECS is a highly scalable, fast, container management service, it is a part of AWS ecosystem. It's incredibly easy to launch containers via ECS. However it is not mentioned in docs / on forums how to launch distributed applications using ECS. The problem is that we have no internal docker network between EC2 nodes, and it is not possible to communicate with docker containers on different nodes by some internal address. In addition, there is no API (or such API was not found / mentioned in docs / on forums) to launch containers on different nodes. A common use case for ECS is to launch linked containers, to scale it (all linked containers would be just launched on separate node(s)) and to balance requests between these nodes using load balancer. If we want containers to communicate with each other, it is possible to forward all necessary ports to the host network manually (that fact makes impossible spark deployment) and to talk with containers as with nodes.

##### DCOS

DC/OS is a distributed operating system based on the Apache Mesos distributed systems kernel. It has its community version, though DC/OS is mostly (it's supposed) oriented on enterprise users, that explains its unstable latest community version. It has quick start templates for [AWS](https://mesosphere.com/amazon/) and for [DigitalOcean](https://docs.mesosphere.com/1.7/administration/installing/cloud/digitalocean/), but has not too easy installation on [any machine](https://dcos.io/docs/1.7/administration/installing/custom/) (it is not a one-liner). 

For research was used AWS template, [modified](https://gist.github.com/pomadchin/c898fb767ce4d8bb943c2794c565fa8c) to use spot instances. DC/OS operates with mesos dns, and it makes possible docker containers communication on separate nodes. To manage docker container is used [Marathon](https://mesosphere.github.io/marathon/). All docker containers start with its own internal IP addresses (available via mesos dns), but they are not accessable by potentially exposed ports as marathon specification requires explicit ports forwarding at least to mesos internal network. That means that you can't start two containers on the same mesos node with the same exposed port, and there is no in-built ports autoforwarding (on some internal docker network). It is not possible to start our own dockerized Spark using Marathon due to that DC/OS feature. As a fastests and simpliest solution for deployment, it is possible to start DC/OS in-built Hadoop and Spark packages, and to start Accumulo uising [this](https://gist.github.com/pomadchin/2193ed3a10808e9368d326a0cebe393f) Marathon job specification. To solve Marathon dns restrictions (as a consequence ports auto forwarding) it is possible to use [Calico](https://www.projectcalico.org/) (not workable in the current DC/OS AWS template due to old docker version), and [Weave](https://www.weave.works/) (still has no Weave.Net package for DC/OS).

##### Rancher

Rancher is a completely open source docker management system. It has a quite easy [insallation](http://docs.rancher.com/rancher/latest/en/installing-rancher/installing-server/) (one liner) and may works with AWS and DigitalOcean using API. It is possible to provide slave nodes for Rancher manually (just by running another one liner on potential slaves) and it takes controll _over all_ docker containers on them. Rancher includes support for multiple orchestration frameworks: Cattle (native orchestrator), Docker Swarm, Kubernetes, Mesos (beta support), and it provides its own dns on top of docker bridges. Cattle supports a bit modified v1 docker-compose yml files, and to launch it using Cattle is possible via [rancher-compose](http://docs.rancher.com/rancher/v1.0/zh/rancher-compose/). However rancher provides dns on top of docker bridges that causes a following problem with Spark: Spark master listens to `localhost` / `container_name` and this name in terms of a master container is an internal _docker_ ip address (17x.xxx.xxx), and in terms of some other container master address is an internal _rancher_ ip address (10.xxx.xxx), that makes master not available for other containers. Similar thing happens with Accumulo, it writes wrong ip addresses / dns records into Zookeeper and Accumulo master just is not available for tablets / other Accumulo processes. 

Consequences
------------
Deployment solution is still not found. ECS is an Amazon service and we can just await necessary functionality. DC/OS Community version is _very_ unstable, and has some not trival dns problems requiring (at the current moment) third-party libraries (Calico, Weave) usage and not trival installation proccess (generally). Rancher looks more stable, and has more user-friendly (that means simplier to understand) ui / tools. But Rancher has it's own specific features to be explored and probably requires more time to research it.