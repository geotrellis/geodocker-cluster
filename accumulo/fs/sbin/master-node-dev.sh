echo -n "Waiting for TCP connection to ${HADOOP_MASTER_ADDRESS}..."

while ! hadoop fs -ls / 2>/dev/null
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

if ! $(hadoop fs -test -d /accumulo); then
  hadoop fs -mkdir -p /accumulo-classpath && accumulo init --instance-name ${INSTANCE_NAME} --password ${ACCUMULO_PASSWORD}
fi
