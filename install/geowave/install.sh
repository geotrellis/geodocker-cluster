export HADOOP_VERSION=2.6.0
export GEOTOOLS_VERSION=14.2
export GEOSERVER_VERSION=2.8.2

docker exec -it master1 bash -c ". ~/.bashrc && rm -rf ./geowave && git clone https://github.com/ngageoint/geowave.git && cd ./geowave && \
                                 mvn clean install -Dmaven.test.skip=true -Dhadoop.version=${HADOOP_VERSION} -Dgeotools.version=${GEOTOOLS_VERSION} -Dgeoserver.version=${GEOSERVER_VERSION} && \
                                 mvn install -Dmaven.test.skip=true -Dhadoop.version=${HADOOP_VERSION} -Dgeotools.version=${GEOTOOLS_VERSION} -Dgeoserver.version=${GEOSERVER_VERSION} && \
                                 mvn package -P geowave-tools-singlejar -Dmaven.test.skip=true -Dhadoop.version=${HADOOP_VERSION} -Dgeotools.version=${GEOTOOLS_VERSION} -Dgeoserver.version=${GEOSERVER_VERSION} && \
                                 mvn package -P accumulo-container-singlejar -Dmaven.test.skip=true -Dhadoop.version=${HADOOP_VERSION} -Dgeotools.version=${GEOTOOLS_VERSION} -Dgeoserver.version=${GEOSERVER_VERSION} && \
                                 hadoop fs -mkdir -p /accumulo/system-classpath && \
                                 hadoop fs -copyFromLocal deploy/target/geowave-deploy-0.9.1-SNAPSHOT-accumulo-singlejar.jar /accumulo/system-classpath/ && \
                                 accumulo shell -u root -p secret -e \"createuser geowave\" && \
                                 accumulo shell -u root -p secret -e \"createnamespace geowave\" && \
                                 accumulo shell -u root -p secret -e \"grant NameSpace.CREATE_TABLE -ns geowave -u geowave\""