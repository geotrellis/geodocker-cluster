#! /usr/bin/env bash
set -eo pipefail

GEOMESA_VERSION="1.2.2"
GEOWAVE_VERSION="0.9.1"
LIB_DIR="/opt/accumulo/lib/ext/"


# Obtaining GEOMESA iterators
echo "Downloading geomesa"
wget -qO- http://repo.locationtech.org/content/repositories/geomesa-releases/org/locationtech/geomesa/geomesa-dist/${GEOMESA_VERSION}/geomesa-dist-${GEOMESA_VERSION}-bin.tar.gz \
  | tar xvz -C /opt/

# Put the geomesa libs on the dynamic classpath
echo "adding joda-time"
wget https://bitbucket.org/pomadchin/binary/raw/c5b0ea0aa98de751f56848d9915a9b6a4ee8f3df/geo/joda-time-2.3.jar \
  -O ${LIB_DIR}joda-time-2.3.jar

cp /opt/geomesa-${GEOMESA_VERSION}/dist/accumulo/geomesa-accumulo-distributed-runtime-${GEOMESA_VERSION}.jar \
  ${LIB_DIR}geomesa-accumulo-distributed-runtime-${GEOMESA_VERSION}.jar

# Geomesa command line
tar -xf /opt/geomesa-${GEOMESA_VERSION}/dist/tools/geomesa-tools-${GEOMESA_VERSION}-bin.tar.gz -C /opt/geomesa-${GEOMESA_VERSION}/dist/tools/
rm -rf /opt/geomesa-${GEOMESA_VERSION}/dist/tools/geomesa-tools-${GEOMESA_VERSION}-bin.tar.gz

# Set var to keep DRY
GEOMESA_HOME=/opt/geomesa-${GEOMESA_VERSION}/dist/tools/geomesa-tools-${GEOMESA_VERSION}
echo "export GEOMESA_HOME=${GEOMESA_HOME}" >> ~/.bashrc
echo "export PATH=${GEOMESA_HOME}/bin:$PATH" >> ~/.bashrc
source ~/.bashrc

# User prompt here
if ! $(ls /opt/geomesa-1.2.2/dist/tools/geomesa-tools-1.2.2/lib/common/jai_core* 1> /dev/null 2>&1); then
  ${GEOMESA_HOME}/bin/install-jai
else
  echo "JAI already installed, skipping..."
fi

if ! $(ls /opt/geomesa-1.2.2/dist/tools/geomesa-tools-1.2.2/lib/common/jline* 1> /dev/null 2>&1); then
  ${GEOMESA_HOME}/bin/install-jline
else
  echo "Jline already installed, skipping..."
fi
echo "Geomesa iterator loaded successfully"


# Obtaining GEOWAVE iterators
echo "Downloading geowave"
rpm -Uvh --replacepkgs http://s3.amazonaws.com/geowave-rpms/release/noarch/geowave-repo-1.0-3.noarch.rpm
yum --enablerepo=geowave install -y geowave-${GEOWAVE_VERSION}-apache-accumulo
yum --enablerepo=geowave install -y geowave-${GEOWAVE_VERSION}-apache-tools

# Put the geowave libs on the dynamic classpath
cp /usr/local/geowave/accumulo/geowave-accumulo.jar ${LIB_DIR}geowave-accumulo.jar
echo "Geowave iterators loaded successfully"

