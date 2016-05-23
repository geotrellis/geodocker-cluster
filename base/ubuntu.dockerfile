FROM ubuntu:14.04

MAINTAINER Pomadchin Grigory, daunnc@gmail.com

ENV USER root
ENV HOME /root
ENV TERM xterm
ENV LC_ALL C
ENV DEBIAN_FRONTEND noninteractive

RUN set -x && \
    apt-get update -qq && \
    apt-get upgrade -qqy --no-install-recommends && \
    apt-get install -qqy --no-install-recommends unzip curl wget nano software-properties-common ca-certificates language-pack-en && \
    locale-gen en_US && \
    update-locale LANG=en_US.UTF-8 LC_CTYPE=en_US.UTF-8 && \
    rm -rf /var/lib/apt/lists/*

ENV LANG en_US.UTF-8
ENV LC_CTYPE en_US.UTF-8

# Install Oracle Java 8
RUN set -x && \
    echo "oracle-java7-installer shared/accepted-oracle-license-v1-1 boolean true" | debconf-set-selections && \
    add-apt-repository ppa:webupd8team/java && \
    apt-get -qq update && \
    apt-get install -qqy --no-install-recommends oracle-java8-installer && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /var/cache/oracle-jdk8-installer

ENV JAVA_HOME /usr/lib/jvm/java-8-oracle
ENV PATH $PATH:$JAVA_HOME/bin

RUN useradd -ms /bin/bash hadoop
