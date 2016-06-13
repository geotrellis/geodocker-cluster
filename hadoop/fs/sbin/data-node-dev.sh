
export PORT="50070"

echo -n "Waiting for TCP connection to ${HADOOP_MASTER_ADDRESS}:${PORT}..."

echo "Waiting for HDFS to be ready..."
while ! nc -w 1 ${HADOOP_MASTER_ADDRESS} ${PORT} 2>/dev/null
do
  echo -n .
  sleep 1
done

echo "Ok."

touch hdfsready
hadoop fs -copyFromLocal -f hdfsready /
