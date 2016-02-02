#!/bin/bash
. /root/.bashrc

/usr/bin/svscan /etc/service/ &
sleep 4
sudo -u hduser bash -c "echo $ZOOKEEPER_ID > /var/zookeeper/myid"
sudo -u hduser bash -c "ssh -l hduser master1.gt 'bash -l -c \"zkServer.sh start\"'"
# su hduser -c "ssh -l hduser slave1.gt 'bash -l -c \"zkServer.sh start\"'"
# su hduser -c "ssh -l hduser slave2.gt 'bash -l -c \"zkServer.sh start\"'"
if [ "$NODE_TYPE" = "m" ]; then
   sudo -u hduser bash -c "$HADOOP_INSTALL/sbin/start-dfs.sh"
   sudo -u hduser bash -c "$HADOOP_INSTALL/sbin/start-yarn.sh"
fi
sleep 4
sudo -u hduser bash -c "$ACCUMULO_HOME/bin/accumulo init --instance-name gis --password secret"
sudo -u hduser bash -c "$ACCUMULO_HOME/bin/start-all.sh"
sudo -u hduser bash -c "$SPARK_HOME/sbin/start-all.sh"
# tail -f $HADOOP_INSTALL/logs/*
while true; do sleep 1; done
