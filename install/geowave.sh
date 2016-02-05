ACCUMULO_HOME=/usr/local/accumulo

docker exec -it master1 bash -c ". ~/.bashrc && rm -rf ./geowave && git clone https://github.com/ngageoint/geowave.git && \
                                 cd ./geowave && \
                                 mvn install -Dmaven.test.skip=true && mvn install -Dmaven.test.skip=true && \
                                 mvn package -P geowave-tools-singlejar -Dmaven.test.skip=true && \
                                 mvn package -P geotools-container-singlejar -Dmaven.test.skip=true && \
                                 mvn package -P accumulo-container-singlejar -Dmaven.test.skip=true && \
                                 hadoop fs -mkdir -p /accumulo/system-classpath && \
                                 hadoop fs -copyFromLocal deploy/target/geowave-deploy-0.9.1-SNAPSHOT-accumulo-singlejar.jar /accumulo/system-classpath/ && \
                                 accumulo shell -u root -p secret -e \"createuser geowave\" && \
                                 accumulo shell -u root -p secret -e \"createnamespace geowave\" && \ 
                                 accumulo shell -u root -p secret -e \"grant NameSpace.CREATE_TABLE -ns geowave -u geowave\""