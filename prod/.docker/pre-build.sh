#!/bin/bash

for i in "$@"
do
case $i in
    -hms=*|--hadoop-master-address=*)
    HADOOP_MASTER_ADDRESS="${i#*=}"
    shift
    ;;
    -az=*|--accumulo-zookeepers=*)
    ACCUMULO_ZOOKEEPERS="${i#*=}"
    shift
    ;;
    -as=*|--accumulo-secret=*)
    ACCUMULO_SECRET="${i#*=}"
    shift
    ;;
    -ap=*|--accumulo-password=*)
    ACCUMULO_PASSWORD="${i#*=}"
    shift
    ;;
    --refresh*)
    REFRESH=true
    shift
    ;;
    *)
    ;;
esac
done

HMS="{HADOOP_MASTER_ADDRESS}"
AZ="{ACCUMULO_ZOOKEEPERS}"
AS="{ACCUMULO_SECRET}"
AP="{ACCUMULO_PASSWORD}"

HADOOP_MASTER_ADDRESS=${HADOOP_MASTER_ADDRESS:-$HMS}
ACCUMULO_ZOOKEEPERS=${ACCUMULO_ZOOKEEPERS:-$AZ}
ACCUMULO_SECRET=${ACCUMULO_SECRET:-$AS}
ACCUMULO_PASSWORD=${ACCUMULO_PASSWORD:-$AP}
REFRESH=${REFRESH:-false}

if ${REFRESH}; then
  rm -f hadoop/base/fs/opt/hadoop/etc/hadoop/core-site.xml; git checkout hadoop/base/fs/opt/hadoop/etc/hadoop/core-site.xml
  rm -f accumulo/base/fs/opt/accumulo/conf/accumulo-site.xml; git checkout accumulo/base/fs/opt/accumulo/conf/accumulo-site.xml  
else
  echo "sed -i.bak \"s/{HADOOP_MASTER_ADDRESS}/${HADOOP_MASTER_ADDRESS}/g\" hadoop/base/fs/opt/hadoop/etc/hadoop/core-site.xml"
  sed -i.bak "s/{HADOOP_MASTER_ADDRESS}/${HADOOP_MASTER_ADDRESS}/g" hadoop/base/fs/opt/hadoop/etc/hadoop/core-site.xml
  echo "sed -i.bak \"s/{HADOOP_MASTER_ADDRESS}/${HADOOP_MASTER_ADDRESS}/g\" hadoop/base/fs/opt/hadoop/etc/hadoop/core-site.xml"
  sed -i.bak "s/{HADOOP_MASTER_ADDRESS}/${HADOOP_MASTER_ADDRESS}/g" accumulo/base/fs/opt/accumulo/conf/accumulo-site.xml
  echo "sed -i.bak \"s/{ACCUMULO_ZOOKEEPERS}/${ACCUMULO_ZOOKEEPERS}/g\" accumulo/base/fs/opt/accumulo/conf/accumulo-site.xml"
  sed -i.bak "s/{ACCUMULO_ZOOKEEPERS}/${ACCUMULO_ZOOKEEPERS}/g" accumulo/base/fs/opt/accumulo/conf/accumulo-site.xml
  echo "sed -i.bak \"s/{ACCUMULO_SECRET}/${ACCUMULO_SECRET}/g\" accumulo/base/fs/opt/accumulo/conf/accumulo-site.xml"
  sed -i.bak "s/{ACCUMULO_SECRET}/${ACCUMULO_SECRET}/g" accumulo/base/fs/opt/accumulo/conf/accumulo-site.xml
  echo "sed -i.bak \"s/{ACCUMULO_PASSWORD}/${ACCUMULO_PASSWORD}/g\" accumulo/base/fs/opt/accumulo/conf/accumulo-site.xml"
  sed -i.bak "s/{ACCUMULO_PASSWORD}/${ACCUMULO_PASSWORD}/g" accumulo/base/fs/opt/accumulo/conf/accumulo-site.xml
fi
