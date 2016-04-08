FROM daunnc/geodocker-spark-base:latest

MAINTAINER Pomadchin Grigory, daunnc@gmail.com

RUN mkdir -p /data/spark

VOLUME [ "/data/spark" ]
# EXPOSE 7078 8081 40000-41000

CMD /bin/bash -c "spark-class org.apache.spark.deploy.worker.Worker --host $(hostname) spark://${SPARK_MASTER}:7077"
