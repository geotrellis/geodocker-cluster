FROM daunnc/geodocker-hadoop-base:latest

MAINTAINER Pomadchin Grigory, daunnc@gmail.com

ENV ACCUMULO_VERSION 1.6.5
ENV ACCUMULO_HOME /opt/accumulo
ENV ACCUMULO_CONF_DIR ACCUMULO_HOME/conf
ENV PATH $PATH:$ACCUMULO_HOME/bin

RUN set -x && \
    mkdir -p ${ACCUMULO_HOME} ${ACCUMULO_CONF_DIR} && \
    curl -# http://archive.apache.org/dist/accumulo/${ACCUMULO_VERSION}/accumulo-${ACCUMULO_VERSION}-bin.tar.gz | tar -xz -C ${ACCUMULO_HOME} --strip-components=1 && \
    cp ${ACCUMULO_HOME}/conf/examples/3GB/standalone/* ${ACCUMULO_CONF_DIR}/

COPY ./fs /

WORKDIR "${ACCUMULO_HOME}"
