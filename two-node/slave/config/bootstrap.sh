#!/bin/bash

/usr/bin/svscan /etc/service/ &
sleep 4
su hduser -c "echo $ZOOKEEPER_ID > /var/zookeeper/myid"
# tail -f $HADOOP_INSTALL/logs/*
while true; do sleep 1; done
