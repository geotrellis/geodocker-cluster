#!/usr/bin/env bash

if [[ ! -v ${HADOOP_MASTER_ADDRESS} ]]; then
  sed -i.bak "s/{HADOOP_MASTER_ADDRESS}/${HADOOP_MASTER_ADDRESS}/g" ${HADOOP_CONF_DIR}/core-site.xml
fi

if  [[ ! -f /data/hdfs/name/current/VERSION ]]; then
  echo "Formatting namenode root fs in /data/hdfs/name"
  hdfs namenode -format
  echo
fi

exec $@
