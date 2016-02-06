docker exec -it master1 bash -c ". ~/.bashrc && rm -rf ./geomesa && \
                                 cd ./geomesa && git pull \
                                 mvn clean install -Dmaven.test.skip=true && \
                                 hadoop fs -mkdir -p /accumulo/system-classpath && \
                                 hadoop fs -rm /accumulo/system-classpath/geomesa-accumulo-distributed-runtime-1.2.0-SNAPSHOT.jar && \
                                 hadoop fs -copyFromLocal geomesa-accumulo/geomesa-accumulo-distributed-runtime/target/geomesa-accumulo-distributed-runtime-1.2.0-SNAPSHOT.jar /accumulo/system-classpath/ && \
                                 cd ../geomesa-tutorials &&  git pull && \
                                 mvn clean install -f geomesa-quickstart-accumulo/pom.xml -Dmaven.test.skip=true"