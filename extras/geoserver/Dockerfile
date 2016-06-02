FROM geodocker-pbase:latest

ENV CATALINA_OPTS="-Xmx4g -XX:MaxPermSize=512M -Duser.timezone=UTC -server -Djava.awt.headless=true"

RUN groupadd tomcat && \
  useradd -M -s /bin/nologin -g tomcat -d /opt/tomcat tomcat

# Install tomcat
RUN wget -O /tmp/tomcat.tar.gz https://archive.apache.org/dist/tomcat/tomcat-8/v8.0.35/bin/apache-tomcat-8.0.35.tar.gz
RUN tar -xvf /tmp/tomcat.tar.gz -C /opt/
RUN rm -rf /tmp/tomcat.tar.gz

# Install geoserver
RUN wget -O /tmp/geoserver.zip http://downloads.sourceforge.net/project/geoserver/GeoServer/2.8.3/geoserver-2.8.3-war.zip
RUN cd /tmp && unzip /tmp/geoserver.zip geoserver.war
RUN unzip /tmp/geoserver.war -d /opt/apache-tomcat-8.0.35/webapps/geoserver
RUN rm -rf /tmp/geoserver.zip /tmp/geoserver.war

# Install geoserver WPS plugin
RUN wget -O /tmp/geoserver-wps.zip http://downloads.sourceforge.net/project/geoserver/GeoServer/2.8.3/extensions/geoserver-2.8.3-wps-plugin.zip
RUN unzip /tmp/geoserver-wps.zip -d /opt/apache-tomcat-8.0.35/webapps/geoserver/WEB-INF/lib/
RUN rm -rf /tmp/geoserver-wps.zip

COPY ./server.xml /opt/apache-tomcat-8.0.35/conf/server.xml

# Install geomesa specific geoserver jar
RUN wget -O /tmp/geomesa-1.2.2.tar.gz https://repo.locationtech.org/content/repositories/geomesa-releases/org/locationtech/geomesa/geomesa-dist/1.2.2/geomesa-dist-1.2.2-bin.tar.gz
RUN cd /tmp && tar -zxf geomesa-1.2.2.tar.gz geomesa-1.2.2/dist/accumulo/geomesa-accumulo-distributed-runtime-1.2.2.jar
RUN mv /tmp/geomesa-1.2.2/dist/accumulo/geomesa-accumulo-distributed-runtime-1.2.2.jar /opt/apache-tomcat-8.0.35/webapps/geoserver/WEB-INF/lib/
RUN rm -rf /tmp/geomesa-1.2.2.tar.gz

# Install jars for geomesa/geowave integration
RUN cd /opt/apache-tomcat-8.0.35/webapps/geoserver/WEB-INF/lib/ && \
  wget http://repo1.maven.org/maven2/org/apache/accumulo/accumulo-core/1.7.1/accumulo-core-1.7.1.jar && \
  wget http://repo1.maven.org/maven2/org/apache/accumulo/accumulo-fate/1.7.1/accumulo-fate-1.7.1.jar && \
  wget http://repo1.maven.org/maven2/org/apache/accumulo/accumulo-server-base/1.7.1/accumulo-server-base-1.7.1.jar && \
  wget http://repo1.maven.org/maven2/org/apache/accumulo/accumulo-trace/1.7.1/accumulo-trace-1.7.1.jar && \
  wget http://repo1.maven.org/maven2/org/apache/thrift/libthrift/0.9.3/libthrift-0.9.3.jar && \
  wget http://repo1.maven.org/maven2/org/apache/zookeeper/zookeeper/3.4.6/zookeeper-3.4.6.jar && \
  wget http://repo1.maven.org/maven2/commons-configuration/commons-configuration/1.10/commons-configuration-1.10.jar && \
  wget http://repo1.maven.org/maven2/org/apache/hadoop/hadoop-auth/2.7.2/hadoop-auth-2.7.2.jar && \
  wget http://repo1.maven.org/maven2/org/apache/hadoop/hadoop-common/2.7.2/hadoop-common-2.7.2.jar && \
  wget http://repo1.maven.org/maven2/org/apache/hadoop/hadoop-hdfs/2.7.2/hadoop-hdfs-2.7.2.jar && \
  wget http://central.maven.org/maven2/org/apache/htrace/htrace-core/3.1.0-incubating/htrace-core-3.1.0-incubating.jar


EXPOSE 9090
CMD ["/opt/apache-tomcat-8.0.35/bin/catalina.sh", "run"]
