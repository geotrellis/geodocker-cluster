FROM daunnc/geodocker-hadoop-base:latest

MAINTAINER Pomadchin Grigory, daunnc@gmail.com

ARG SCALA_VERSION

ENV SCALA_VERSION ${SCALA_VERSION:-2.10}
ENV SPARK_VERSION 1.5.2
ENV SPARK_HOME /opt/spark
ENV SPARK_CONF_DIR $SPARK_HOME/conf
ENV PATH $PATH:$SPARK_HOME/bin:$SPARK_HOME/sbin

RUN set -x && \
    mkdir -p $SPARK_HOME $SPARK_CONF_DIR && \
    /bin/bash -c 'curl -# https://bitbucket.org/pomadchin/binary/raw/0c00a52952a3d7cada14aa0e36558fd628336273/spark/spark-${SPARK_VERSION}-bin-hadoop-2.6_scala-${SCALA_VERSION}.tgz | tar -xz -C ${SPARK_HOME} --strip-components=`if [ "$SCALA_VERSION" == "2.11" ]; then echo 2; else echo 1; fi`'

COPY ./fs /

WORKDIR "${SPARK_HOME}"
ENTRYPOINT [ "/sbin/entrypoint.sh" ]
