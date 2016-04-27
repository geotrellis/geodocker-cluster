#!/bin/bash
source .cluster-conf

cat scripts/acc-init.sh | vagrant ssh master

echo "Sleeping to give accumulo time to wake up"
sleep 10

cat scripts/acc-restart-master.sh | vagrant ssh master


for (( i=1; i <= $SLAVES; i++ ))
do
 cat scripts/acc-restart-slave.sh | vagrant ssh slave-$i
done
