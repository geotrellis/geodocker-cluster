FROM daunnc/serf:latest

MAINTAINER Pomadchin Grigory, daunnc@gmail.com

ARG ACCUMULO_VERSION
ENV HADOOP_VERSION 2.7.2
ENV SPARK_VERSION 1.5.2
ENV ACCUMULO_VERSION ${ACCUMULO_VERSION:-1.7.0}
ENV ZOOKEEPER_VERSION 3.4.6
ENV JAVA_GDAL_DIR /usr/lib/jni/

# Update Ubuntu
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y maven llvm-gcc build-essential zlib1g-dev make cmake pkg-config libssl-dev \ 
    automake autoconf curl zip unzip imagemagick gdal-bin python-gdal python python-setuptools \
    python-numpy python-pip python-dev python-scipy libgdal-dev libgdal1-dev libgdal-java geotiff-bin 

# Add oracle java repository
RUN apt-get -y install software-properties-common
RUN add-apt-repository ppa:webupd8team/java
RUN apt-get -y update

# Accept the Oracle Java license
RUN echo "oracle-java8-installer shared/accepted-oracle-license-v1-1 boolean true" | debconf-set-selections

# Install Oracle Java
RUN apt-get -y install oracle-java8-installer

RUN update-alternatives --display java

ENV JAVA_HOME /usr/lib/jvm/java-8-oracle/ 
ENV PATH $PATH:$JAVA_HOME/bin

RUN addgroup hadoop
RUN useradd -d /home/hduser -m -s /bin/bash -G hadoop hduser

RUN apt-get install -y openssh-server
RUN mkdir /var/run/sshd
RUN su hduser -c "ssh-keygen -t rsa -f ~/.ssh/id_rsa -P ''"
RUN su hduser -c "cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys" 
ADD config/ssh_config ./ssh_config
RUN mv ./ssh_config /home/hduser/.ssh/config

# Hadoop
RUN curl -s http://www.eu.apache.org/dist/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz | tar -xz -C /usr/local
RUN ln -s /usr/local/hadoop-${HADOOP_VERSION} /usr/local/hadoop

# fixing the libhadoop.so like a boss
RUN rm  /usr/local/hadoop/lib/native/*
RUN curl -Ls https://storage.googleapis.com/hdfs-bucket/hadoop/hadoop-native-64-${HADOOP_VERSION}.tar | tar -x -C /usr/local/hadoop/lib/native/

RUN chown -R hduser:hadoop /usr/local/hadoop-${HADOOP_VERSION}

ADD config/bashrc /home/hduser/.bashrc
ADD config/bashrc /root/.bashrc
RUN mkdir -p /home/hduser/hdfs/datanode
RUN mkdir -p /home/hduser/hdfs/namenode
RUN chown -R hduser:hadoop /home/hduser/hdfs

RUN rm -f /usr/local/hadoop/etc/hadoop/hadoop-env.sh 
ADD hadoop/hadoop-env.sh /usr/local/hadoop/etc/hadoop/hadoop-env.sh 

# Zookeeper
RUN curl -s http://mirror.cc.columbia.edu/pub/software/apache/zookeeper/zookeeper-${ZOOKEEPER_VERSION}/zookeeper-${ZOOKEEPER_VERSION}.tar.gz | tar -xz -C /usr/local
RUN ln -s /usr/local/zookeeper-${ZOOKEEPER_VERSION} /usr/local/zookeeper
RUN chown -R hduser:hadoop /usr/local/zookeeper
RUN mkdir -p /var/zookeeper
RUN mkdir -p /var/log/zookeeper
RUN chown -R hduser:hadoop /var/zookeeper
RUN chown -R hduser:hadoop /var/log/zookeeper

# Accumulo
RUN curl -s http://archive.apache.org/dist/accumulo/${ACCUMULO_VERSION}/accumulo-${ACCUMULO_VERSION}-bin.tar.gz | tar -xz -C /usr/local
RUN ln -s /usr/local/accumulo-${ACCUMULO_VERSION} /usr/local/accumulo
RUN rm -r /usr/local/accumulo/logs && mkdir /usr/local/accumulo/logs 
RUN mkdir -p /usr/local/accumulo/walogs
RUN chown -R hduser:hadoop /usr/local/accumulo/

# Spark
RUN curl -s http://d3kbcqa49mib13.cloudfront.net/spark-${SPARK_VERSION}-bin-hadoop2.6.tgz | tar -xz -C /usr/local/
RUN ln -s /usr/local/spark-${SPARK_VERSION}-bin-hadoop2.6 /usr/local/spark
RUN chown -R hduser:hadoop /usr/local/spark
RUN mkdir -p /home/hduser/spark/tmp
RUN chown -R hduser:hadoop /home/hduser/spark/tmp
RUN mkdir -p /home/hduser/spark/work
RUN chown -R hduser:hadoop /home/hduser/spark/work

RUN echo -e "\n* soft nofile 65536\n* hard nofile 65536" >> /etc/security/limits.conf

EXPOSE 22
