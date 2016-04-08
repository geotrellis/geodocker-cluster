FROM daunnc/geodocker-hadoop-base:latest

MAINTAINER Pomadchin Grigory, daunnc@gmail.com

COPY ./fs /

VOLUME [ "/data/hdfs" ]
# EXPOSE 8020 50070

ENTRYPOINT [ "/sbin/entrypoint.sh" ]
CMD [ "hdfs", "namenode" ]
