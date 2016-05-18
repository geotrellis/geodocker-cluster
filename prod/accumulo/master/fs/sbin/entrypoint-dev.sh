#! /usr/bin/env bash

set -eo pipefail

export PORT="50010"

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

echo -n "Waiting for TCP connection to ${HADOOP_MASTER_ADDRESS}:${PORT}..."

while ! nc -w 1 HADOOP_MASTER_ADDRESS PORT 2>/dev/null
do
  echo -n .
  sleep 1
done

echo "Ok."

echo -n "Waiting for TCP connection to ${ACCUMULO_ZOOKEEPERS}:2181..."

while ! nc -w 1 ${ACCUMULO_ZOOKEEPERS} 2181 2>/dev/null
do
  echo -n .
  sleep 1
done

echo "Ok."

bash -c "hadoop fs -mkdir -p /accumulo-classpath && accumulo init --instance-name gis --password GisPwd"

exec "$@"
