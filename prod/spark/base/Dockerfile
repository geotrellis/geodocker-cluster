FROM daunnc/geodocker-hadoop-base:latest

MAINTAINER Pomadchin Grigory, daunnc@gmail.com

ENV SPARK_VERSION 1.5.2
ENV SPARK_HOME /opt/spark
ENV SPARK_CONF_DIR $SPARK_HOME/conf
ENV PATH $PATH:$SPARK_HOME/bin:$SPARK_HOME/sbin

RUN set -x && \
    mkdir -p $SPARK_HOME $SPARK_CONF_DIR && \
    curl -# http://apache-mirror.rbc.ru/pub/apache/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop2.6.tgz | tar -xz -C ${SPARK_HOME} --strip-components=1

COPY ./fs /

WORKDIR "${SPARK_HOME}"
ENTRYPOINT [ "/sbin/entrypoint.sh" ]