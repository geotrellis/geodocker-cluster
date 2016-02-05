ACCUMULO_HOME=/usr/local/accumulo

docker exec -it master1 basch -c ". ~/.bashrc && \
                                  rm -rf geotrellis && git clone https://github.com/geotrellis/geotrellis.git && \
                                  cd ./geotrellis && ./publish-local.sh"