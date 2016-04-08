FROM daunnc/serf:latest

MAINTAINER Pomadchin Grigory, daunnc@gmail.com

ARG SCALA_VERSION
ARG ACCUMULO_VERSION

ENV SCALA_VERSION ${SCALA_VERSION:-2.10}
ENV HADOOP_VERSION 2.7.1
ENV SPARK_VERSION 1.5.2
ENV ACCUMULO_VERSION ${ACCUMULO_VERSION:-1.7.1}
ENV ZOOKEEPER_VERSION 3.4.6
ENV JAVA_GDAL_DIR /usr/lib/jni/

# Update Ubuntu & add oracle java repository
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y maven llvm-gcc build-essential zlib1g-dev make cmake pkg-config libssl-dev \ 
    automake autoconf curl zip unzip git imagemagick gdal-bin python-gdal python python-setuptools \
    python-numpy python-pip python-dev python-scipy libgdal-dev libgdal1-dev libgdal-java geotiff-bin \
    software-properties-common && add-apt-repository ppa:webupd8team/java && apt-get -y update

# Accept the Oracle Java license
RUN echo "oracle-java8-installer shared/accepted-oracle-license-v1-1 boolean true" | debconf-set-selections

# Install Oracle Java
RUN apt-get -y install oracle-java8-installer && update-alternatives --display java

ENV JAVA_HOME /usr/lib/jvm/java-8-oracle/ 
ENV PATH $PATH:$JAVA_HOME/bin

RUN addgroup hadoop && useradd -d /home/hduser -m -s /bin/bash -G hadoop hduser

RUN apt-get install -y openssh-server && mkdir /var/run/sshd && \ 
    su hduser -c "ssh-keygen -t rsa -f ~/.ssh/id_rsa -P ''" && \
    su hduser -c "cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys" 
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
RUN mkdir -p /home/hduser/hdfs/datanode && mkdir -p /home/hduser/hdfs/namenode && chown -R hduser:hadoop /home/hduser/hdfs

RUN rm -f /usr/local/hadoop/etc/hadoop/hadoop-env.sh 
ADD hadoop/hadoop-env.sh /usr/local/hadoop/etc/hadoop/hadoop-env.sh 

# Zookeeper
RUN curl -s http://mirror.cc.columbia.edu/pub/software/apache/zookeeper/zookeeper-${ZOOKEEPER_VERSION}/zookeeper-${ZOOKEEPER_VERSION}.tar.gz | tar -xz -C /usr/local
RUN mv /usr/local/zookeeper-${ZOOKEEPER_VERSION} /usr/local/zookeeper && \
    chown -R hduser:hadoop /usr/local/zookeeper && mkdir -p /var/zookeeper && \
    mkdir -p /var/log/zookeeper && chown -R hduser:hadoop /var/zookeeper && chown -R hduser:hadoop /var/log/zookeeper

# Accumulo
RUN curl -s http://archive.apache.org/dist/accumulo/${ACCUMULO_VERSION}/accumulo-${ACCUMULO_VERSION}-bin.tar.gz | tar -xz -C /usr/local
RUN mv /usr/local/accumulo-${ACCUMULO_VERSION} /usr/local/accumulo && \
    rm -r /usr/local/accumulo/logs && mkdir /usr/local/accumulo/logs && \
    mkdir -p /usr/local/accumulo/walogs && chown -R hduser:hadoop /usr/local/accumulo/

# Spark
RUN curl -s https://bitbucket.org/pomadchin/binary/raw/0c00a52952a3d7cada14aa0e36558fd628336273/spark/spark-${SPARK_VERSION}-bin-hadoop-2.6_scala-${SCALA_VERSION}.tgz | tar -xz -C /usr/local/
RUN mv /usr/local/spark-${SPARK_VERSION}-bin-hadoop2.6 /usr/local/spark
RUN chown -R hduser:hadoop /usr/local/spark && mkdir -p /home/hduser/spark/tmp && \
    chown -R hduser:hadoop /home/hduser/spark/tmp && mkdir -p /home/hduser/spark/work && \
    chown -R hduser:hadoop /home/hduser/spark/work

RUN echo -e "\n* soft nofile 65536\n* hard nofile 65536" >> /etc/security/limits.conf

EXPOSE 22
