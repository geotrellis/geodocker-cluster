#! /usr/bin/env bash

set -eo pipefail

export $HADOOP_MASTER_ADDRESS="geodocker-hadoop-data"
export $ACCUMULO_ZOOKEEPERS="geodocker-zookeeper"
export $ACCUMULO_SECRET="secret"
export $ACCUMULO_PASSWORD="GisPwd"

if [[ ! -v ${HADOOP_MASTER_ADDRESS} ]]; then
  sed -i.bak "s/{HADOOP_MASTER_ADDRESS}/${HADOOP_MASTER_ADDRESS}/g" ${HADOOP_CONF_DIR}/core-site.xml
  sed -i.bak "s/{HADOOP_MASTER_ADDRESS}/${HADOOP_MASTER_ADDRESS}/g" ${ACCUMULO_CONF_DIR}/accumulo-site.xml
fi

if [[ ! -v ${ACCUMULO_ZOOKEEPERS} ]]; then
  sed -i.bak "s/{ACCUMULO_ZOOKEEPERS}/${ACCUMULO_ZOOKEEPERS}/g" ${ACCUMULO_CONF_DIR}/accumulo-site.xml
fi

if [[ ! -v ${ACCUMULO_SECRET} ]]; then
  sed -i.bak "s/{ACCUMULO_SECRET}/${ACCUMULO_SECRET}/g" ${ACCUMULO_CONF_DIR}/accumulo-site.xml
fi

if [[ ! -v ${ACCUMULO_PASSWORD} ]]; then
  sed -i.bak "s/{ACCUMULO_PASSWORD}/${ACCUMULO_PASSWORD}/g" ${ACCUMULO_CONF_DIR}/accumulo-site.xml
fi

echo -n "Waiting for TCP connection to geodocker-accumulo-master:9999..."

while ! nc -w 1 geodocker-accumulo-master 9999 2>/dev/null
do
  echo -n .
  sleep 1
done

echo "Ok."

exec "$@"
