#!/bin/bash
. /root/.bashrc

/usr/bin/svscan /etc/service/ &
sleep 4
su hduser -c "echo $ZOOKEEPER_ID > /var/zookeeper/myid"
su hduser -c "ssh -l hduser master1.gt 'bash -l -c \"zkServer.sh start\"'"
su hduser -c "ssh -l hduser slave1.gt 'bash -l -c \"zkServer.sh start\"'"
su hduser -c "ssh -l hduser slave2.gt 'bash -l -c \"zkServer.sh start\"'"
if [ "$NODE_TYPE" = "m" ]; then
   su hduser -c "$HADOOP_INSTALL/sbin/start-dfs.sh"
   su hduser -c "$HADOOP_INSTALL/sbin/start-yarn.sh"
fi
sleep 4
su hduser -c "$ACCUMULO_HOME/bin/accumulo init --instance-name gis --password secret"
su hduser -c "$ACCUMULO_HOME/bin/start-all.sh"
su hduser -c "$SPARK_HOME/sbin/start-all.sh"
# tail -f $HADOOP_INSTALL/logs/*
while true; do sleep 1; done
