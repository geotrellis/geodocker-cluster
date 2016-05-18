#! /usr/bin/env bash
set -eo pipefail

export $HADOOP_MASTER_ADDRESS="geodocker-hadoop-sname"
export $PORT="50090"

if [[ ! -v ${HADOOP_MASTER_ADDRESS} ]]; then
  sed -i.bak "s/{HADOOP_MASTER_ADDRESS}/${HADOOP_MASTER_ADDRESS}/g" ${HADOOP_CONF_DIR}/core-site.xml
fi

echo -n "Waiting for TCP connection to ${HADOOP_MASTER_ADDRESS}:${PORT}..."

while ! nc -w 1 $HADOOP_MASTER_ADDRESS $PORT 2>/dev/null
do
  echo -n .
  sleep 1
done

echo "Ok."

exec "$@"
