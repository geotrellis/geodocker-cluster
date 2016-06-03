#! /usr/bin/env bash
set -eo pipefail

export PORT="50070"

echo -n "Waiting for TCP connection to ${HADOOP_MASTER_ADDRESS}:${PORT}..."

while ! nc -w 1 ${HADOOP_MASTER_ADDRESS} ${PORT} 2>/dev/null
do
  echo -n .
  sleep 1
done

echo "Ok."
