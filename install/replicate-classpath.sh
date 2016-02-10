#!/bin/bash

for i in "$@"
do
case $i in    
    -n=*|--nodes=*)
    NODES="${i#*=}"
    shift
    ;;    
    *)
    ;;
esac
done

NODES=${NODES:-1}

docker exec -it master1 bash -c ". ~/.bashrc; hdfs -setrep -w ${NODES} /accumulo/system-classpath/*"
