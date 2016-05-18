#!/usr/bin/env bash
#
# Bootstrap docker and accumulo on EMR cluster
#

IMAGE=echeipesh/geodocker-accumulo:${TAG:-"latest"}
ACCUMULO_SECRET=DEFAULT
ACCUMULO_PASSWORD=secret
INSTANCE_NAME=accumulo
ARGS=$@

for i in "$@"
do
    case $i in
        --continue)
            CONTINUE=true
            shift
            ;;
        -i=*|--image=*)
            IMAGE="${i#*=}"
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
        -in=*|--instance-name=*)
            INSTANCE_NAME="${i#*=}"
            shift
            ;;

        *)
            ;;
    esac
done


# Parses a configuration file put in place by EMR to determine the role of this node
is_master() {
  if [ $(jq '.isMaster' /mnt/var/lib/info/instance.json) = 'true' ]; then
    return 0
  else
    return 1
  fi
}

is_hdfs_available() {
	  hadoop fs -ls /
	  return $?
}

is_accumulo_init() {
	  hadoop fs -ls /accumulo
	  return $?
}

# Avoid race conditions and actually poll for availability of component dependencies
# Credit: http://stackoverflow.com/questions/8350942/how-to-re-run-the-curl-command-automatically-when-the-error-occurs/8351489#8351489
with_backoff() {
  local max_attempts=${ATTEMPTS-5}
  local timeout=${INTIAL_POLLING_INTERVAL-1}
  local attempt=0
  local exitCode=0

  while (( $attempt < $max_attempts ))
  do
    set +e
    "$@"
    exitCode=$?
    set -e

    if [[ $exitCode == 0 ]]
    then
      break
    fi

    echo "Retrying $@ in $timeout.." 1>&2
    sleep $timeout
    attempt=$(( attempt + 1 ))
    timeout=$(( timeout * 2 ))
  done

  if [[ $exitCode != 0 ]]
  then
    echo "Fail: $@ failed to complete after $max_attempts attempts" 1>&2
  fi

  return $exitCode
}

wait_until_hdfs_is_available() {
	with_backoff is_hdfs_available
	if [ $? != 0 ]; then
		echo "HDFS not available before timeout. Exiting ..."
		exit 1
	fi
}

wait_until_accumulo_is_init() {
	with_backoff is_accumulo_init
	if [ $? != 0 ]; then
		echo "Accumulo not initilized before timeout. Exiting ..."
		exit 1
	fi
}

### MAIN ####

# EMR bootstrap runs before HDFS or YARN are initilized
if [ ! $CONTINUE ]; then
    sudo yum -y install docker
    sudo usermod -aG docker hadoop
    sudo service docker start

    THIS_SCRIPT="$(realpath "${BASH_SOURCE[0]}")"
	  TIMEOUT= is_master && TIMEOUT=3 || TIMEOUT=4
	  echo "bash -x $THIS_SCRIPT --continue $ARGS > /tmp/docker-bootstrap.log" | at now + $TIMEOUT min
	  exit 0 # Bail and let EMR finish initializing
fi

HDFS_ROOT=$(xmllint --xpath "//property[name='fs.defaultFS']/value/text()"  /etc/hadoop/conf/core-site.xml)
ZK_IPADDR=$(xmllint --xpath "//property[name='yarn.resourcemanager.hostname']/value/text()"  /etc/hadoop/conf/yarn-site.xml)
HADOOP_MASTER_ADDRESS=$ZK_IPADDR
DOCKER_ENV="\
--env=HADOOP_MASTER_ADDRESS=$HADOOP_MASTER_ADDRESS \
--env=ACCUMULO_ZOOKEEPERS=$ZK_IPADDR \
--env=ACCUMULO_SECRET=$ACCUMULO_SECRET \
--env=ACCUMULO_PASSWORD=$ACCUMULO_PASSWORD \
--env=INSTANCE_NAME=$INSTANCE_NAME"

wait_until_hdfs_is_available

if is_master ; then
    if ! is_accumulo_init; then
        # TODO This should be done from the accumulo package
        docker run --name=accumulo-init --rm $DOCKER_ENV $IMAGE \
            accumulo init --instance-name $INSTANCE_NAME --password $ACCUMULO_PASSWORD
    fi
    docker run --name=accumulo-master -d --net=host $DOCKER_ENV $IMAGE accumulo master
    docker run --name=accumulo-monitor -d --net=host $DOCKER_ENV $IMAGE accumulo monitor
    docker run --name=accumulo-tracer -d --net=host $DOCKER_ENV $IMAGE accumulo tracer
    docker run --name=accumulo-gc -d --net=host $DOCKER_ENV $IMAGE accumulo gc
else # is worker
    docker run --name=accumulo-tserver -d --net=host $DOCKER_ENV $IMAGE accumulo tserver
fi
