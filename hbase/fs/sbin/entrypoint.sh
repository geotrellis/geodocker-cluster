#!/bin/sh

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x

srcdir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# shell breaks and doesn't run zookeeper without this
rm -rf $HBASE_HOME/logs
mkdir -p $HBASE_HOME/logs

# tries to run zookeepers.sh distributed via SSH, run zookeeper manually instead now
# RUN sed -i 's/# export HBASE_MANAGES_ZK=true/export HBASE_MANAGES_ZK=true/' /hbase/conf/hbase-env.sh
$HBASE_HOME/bin/hbase zookeeper &>$HBASE_HOME/logs/zookeeper.log &
$HBASE_HOME/bin/start-hbase.sh
$HBASE_HOME/bin/hbase-daemon.sh start rest
$HBASE_HOME/bin/hbase-daemon.sh start thrift
# /hbase/bin/hbase-daemon.sh start thrift2
# /hbase/bin/hbase shell
# /hbase/bin/stop-hbase.sh
# pkill -f -i zookeeper

tail -f ${HBASE_HOME}/logs/*.{log,out}
