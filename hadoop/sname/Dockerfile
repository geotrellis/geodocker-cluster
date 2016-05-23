FROM daunnc/geodocker-hadoop-base:latest

MAINTAINER Pomadchin Grigory, daunnc@gmail.com

COPY ./fs /

VOLUME [ "/data/hdfs" ]

# EXPOSE 50090

CMD [ "hdfs", "secondarynamenode" ]
