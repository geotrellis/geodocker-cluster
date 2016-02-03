#!/bin/bash

/usr/bin/svscan /etc/service/ &
sleep 4
su hduser -c "echo $ZOOKEEPER_ID > /var/zookeeper/myid"

# slave dynamic
if [ "$NODE_TYPE" = "sd" ]; then
   su hduser -c "echo $HOSTNAME > $HADOOP_INSTALL/etc/hadoop/slaves"
   su hduser -c "echo $HOSTNAME > $ACCUMULO_HOME/conf/slaves"
   su hduser -c "echo $HOSTNAME > $SPARK_HOME/conf/slaves"

   su hduser -c ". /home/hduser/.bashrc; $HADOOP_INSTALL/sbin/start-dfs.sh"
   su hduser -c ". /home/hduser/.bashrc; $HADOOP_INSTALL/sbin/start-yarn.sh"
   su hduser -c ". /home/hduser/.bashrc; $ACCUMULO_HOME/bin/start-here.sh"
   su hduser -c ". /home/hduser/.bashrc; $SPARK_HOME/sbin/start-slave.sh"
fi

# tail -f $HADOOP_INSTALL/logs/*
while true; do sleep 1; done
