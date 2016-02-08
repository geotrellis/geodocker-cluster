docker exec -it master1 bash -c ". ~/.bashrc && \
                                  rm -rf geotrellis && git clone https://github.com/geotrellis/geotrellis.git && \
                                  cd ./geotrellis && ./publish-local.sh && cd ../ && \
                                  rm -rf geotrellis-chatta-demo && git clone https://github.com/pomadchin/geotrellis-chatta-demo.git && \
                                  cd ./geotrellis-chatta-demo/geotrellis && git checkout spark-version && ./sbt assembly && \
                                  zip -d target/scala-2.10/GeoTrellis-Tutorial-Project-assembly-0.1-SNAPSHOT.jar META-INF/ECLIPSEF.RSA && \
                                  zip -d target/scala-2.10/GeoTrellis-Tutorial-Project-assembly-0.1-SNAPSHOT.jar META-INF/ECLIPSEF.SF"

docker cp resources master1:/data/geotrellis-chatta-demo/geotrellis/src/main/
docker cp ingest.sh master1:/data/geotrellis-chatta-demo/geotrellis/