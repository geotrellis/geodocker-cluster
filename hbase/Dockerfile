FROM daunnc/geodocker-zookeeper:latest

MAINTAINER Pomadchin Grigory, daunnc@gmail.com

ENV HBASE_HOME /opt/hbase
ENV HBASE_CONF_DIR $HBASE_HOME/conf
ENV PATH $PATH:$HBASE_HOME/bin

# Install native libs for hadoop
RUN yum install -y snappy snappy-devel lzo lzo-devel hadooplzo hadooplzo-native openssl-devel autoremove hostname ssh

RUN set -x && \
    mkdir -p $HBASE_HOME $HBASE_CONF_DIR && \
    curl -# http://apache-mirror.rbc.ru/pub/apache/hbase/1.2.2/hbase-1.2.2-bin.tar.gz | tar -xz -C ${HBASE_HOME} --strip-components=1

COPY ./fs /

# Stargate  8080  / 8085
# Thrift    9090  / 9095
# HMaster   16000 / 16010
# RS        16201 / 16301
EXPOSE 2181 8080 8085 9090 9095 16000 16010 16201 16301

WORKDIR "${HBASE_HOME}"
CMD [ "/sbin/entrypoint.sh" ]
