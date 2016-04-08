for i in "$@"
do
case $i in
    -t=*|--tag=*)
    TAG="${i#*=}"
    shift
    ;;    
    --publish=*)
    PUBLISH=true
    shift
    *)
    ;;
esac
done

TAG=${TAG:-latest}
PUBLISH=${PUBLISH:-false}

docker tag daunnc/geodocker-zookeeper:latest daunnc/geodocker-zookeeper:${TAG}
docker tag daunnc/geodocker-hadoop-data:latest daunnc/geodocker-hadoop-data:${TAG}
docker tag daunnc/geodocker-hadoop-name:latest daunnc/geodocker-hadoop-name:${TAG}
docker tag daunnc/geodocker-hadoop-sname:latest daunnc/geodocker-hadoop-sname:${TAG}
docker tag daunnc/geodocker-accumulo-gc:latest daunnc/geodocker-accumulo-gc:${TAG}
docker tag daunnc/geodocker-accumulo-master:latest daunnc/geodocker-accumulo-master:${TAG}
docker tag daunnc/geodocker-accumulo-monitor:latest daunnc/geodocker-accumulo-monitor:${TAG}
docker tag daunnc/geodocker-accumulo-tracer:latest daunnc/geodocker-accumulo-tracer:${TAG}
docker tag daunnc/geodocker-accumulo-tserver:latest daunnc/geodocker-accumulo-tserver:${TAG}
docker tag daunnc/geodocker-spark-master:latest daunnc/geodocker-spark-master:${TAG}
docker tag daunnc/geodocker-spark-worker:latest daunnc/geodocker-spark-worker:${TAG}

if ${PUBLISH}; then
  docker push daunnc/geodocker-zookeeper:${TAG}
  docker push daunnc/geodocker-hadoop-data:${TAG}
  docker push daunnc/geodocker-hadoop-name:${TAG}
  docker push daunnc/geodocker-hadoop-sname:${TAG}
  docker push daunnc/geodocker-accumulo-gc:${TAG}
  docker push daunnc/geodocker-accumulo-master:${TAG}
  docker push daunnc/geodocker-accumulo-monitor:${TAG}
  docker push daunnc/geodocker-accumulo-tracer:${TAG}
  docker push daunnc/geodocker-accumulo-tserver:${TAG}
  docker push daunnc/geodocker-spark-master:${TAG}
  docker push daunnc/geodocker-spark-worker:${TAG}
fi
  