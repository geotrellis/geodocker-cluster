#! /usr/bin/env bash
set -eo pipefail

# No matter what, this runs
if [[ ! -v ${HADOOP_MASTER_ADDRESS} ]]; then
  sed -i.bak "s/{HADOOP_MASTER_ADDRESS}/${HADOOP_MASTER_ADDRESS}/g" ${HADOOP_CONF_DIR}/core-site.xml
fi

# If second argument is provided and is "dev", proceed with production setup
if [ -z "$2" ]; then
  env="prod"
else
  if [ $2 = "dev" ]; then
    env="dev"
  else
    env="prod"
  fi
fi

# The first argument determines whether this container runs as data, namenode or secondary namenode
if [ -z "$1" ]; then
  echo "Select the role for this container with the docker cmd 'data', 'name', or 'sname'"
  exit 1
else
  if [ $1 = "data" ]; then
    role="data"
  elif [ $1 = "name" ]; then
    role="name"
  elif [ $1 = "sname" ]; then
    role="sname"
  else
    role="other"
  fi
fi
echo "Running hadoop container in mode: $env with role: $role"

# Run the appropriate startup script (or noop with ':')
if [ $env = "prod" ]; then
  if [ $role = "data" ]; then
    :
  elif [ $role = "name" ]; then
    name-node.sh
  elif [ $role = "sname" ]; then
    :
  fi
elif [ $env = "dev" ]; then
  if [ $role = "data" ]; then
    data-node-dev.sh
  elif [ $role = "name" ]; then
    name-node.sh
  elif [ $role = "sname" ]; then
    sname-node-dev.sh
  fi
fi

if [ $role = "data" ]; then
  hdfs datanode
elif [ $role = "name" ]; then
  hdfs namenode
elif [ $role = "sname" ]; then
  hdfs secondarynamenode
fi

if [ $role = "other" ]; then
  exec "$@"
fi
