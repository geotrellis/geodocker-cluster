#!/bin/bash

docker exec -it master1 bash -c ". ~/.bashrc; cd geowave && mkdir -p ingest && \
                                 wget http://naciscdn.org/naturalearth/50m/cultural/ne_50m_admin_0_countries.zip && \
                                 mv ne_50m_admin_0_countries.zip ingest/ && cd ingest && \
                                 unzip ne_50m_admin_0_countries.zip && rm ne_50m_admin_0_countries.zip && cd .. && \
                                 java -cp /data/geowave/deploy/target/geowave-deploy-0.9.0-tools.jar:/data/geowave/extensions/datastores/accumulo/target/munged/geowave-datastore-accumulo-0.9.0.jar:extensions/formats/geotools-vector/target/geowave-format-vector-0.9.0.jar mil.nga.giat.geowave.core.cli/GeoWaveMain -localingest -b ./ingest -datastore accumulo -user root -password secret -instance gis -zookeeper master1.gt:2181"
