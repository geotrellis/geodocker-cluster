#! /usr/bin/env bash
set -eo pipefail

echo -n "Waiting for TCP connection to geodocker-accumulo-master:9999..."

while ! nc -w 1 geodocker-accumulo-master 9999 2>/dev/null
do
  echo -n .
  sleep 1
done

echo "Ok."
