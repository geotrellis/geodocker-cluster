FROM daunnc/geodocker-hadoop-base:latest

MAINTAINER Pomadchin Grigory, daunnc@gmail.com

COPY ./fs /

VOLUME [ "/data/hdfs" ]
# EXPOSE 50010 50020 50075 50475

CMD [ "hdfs", "datanode" ]
