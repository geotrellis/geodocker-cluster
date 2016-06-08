#! /usr/bin/env bash
set -eo pipefail

GEOMESA_VERSION="1.2.2"
GEOWAVE_VERSION="0.9.1"

if [ -z "$2" ]; then
  echo "Please provide a namespace in which you'd like to register your iterators"
  exit 1
else
  NAMESPACE="$2"
fi

# GEOMESA iterator installation
if [ "$1" = "geomesa" ]; then
  if [ ! -d /opt/geomesa-${GEOMESA_VERSION} ]; then
    echo "Downloading geomesa"
    wget -qO- http://repo.locationtech.org/content/repositories/geomesa-releases/org/locationtech/geomesa/geomesa-dist/${GEOMESA_VERSION}/geomesa-dist-${GEOMESA_VERSION}-bin.tar.gz \
      | tar xvz -C /opt/
  fi

  if ! $(hadoop fs -test -d /geomesa-classpath); then
    hadoop fs -mkdir /geomesa-classpath
  fi

  # Put the geomesa libs off the dynamic classpath
  if ! $(hadoop fs -test -f /geomesa-classpath/joda-time-2.3.jar); then
    echo "adding joda-time to hdfs"
    wget https://bitbucket.org/pomadchin/binary/raw/c5b0ea0aa98de751f56848d9915a9b6a4ee8f3df/geo/joda-time-2.3.jar -O - \
      | hadoop fs -put - /geomesa-classpath/joda-time-2.3.jar
  fi

  if ! $(hadoop fs -test -f /geomesa-classpath/geomesa-accumulo-distributed-runtime-${GEOMESA_VERSION}.jar); then
    echo "pushing geomesa to hdfs"
    hadoop fs -put /opt/geomesa-${GEOMESA_VERSION}/dist/accumulo/geomesa-accumulo-distributed-runtime-${GEOMESA_VERSION}.jar /geomesa-classpath/geomesa-accumulo-distributed-runtime-${GEOMESA_VERSION}.jar
  fi

  # Geomesa command line
  if [ ! -d /opt/geomesa-${GEOMESA_VERSION}/dist/tools/geomesa-tools-${GEOMESA_VERSION} ]; then
    tar -xf /opt/geomesa-${GEOMESA_VERSION}/dist/tools/geomesa-tools-${GEOMESA_VERSION}-bin.tar.gz -C /opt/geomesa-${GEOMESA_VERSION}/dist/tools/
    rm -rf /opt/geomesa-${GEOMESA_VERSION}/dist/tools/geomesa-tools-${GEOMESA_VERSION}-bin.tar.gz
  fi
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

  echo "Creating geomesa namespace '${NAMESPACE}'"
  accumulo shell -u root -p ${ACCUMULO_PASSWORD} -e "createnamespace ${NAMESPACE}"

  echo "Granting table creation rights..."
  accumulo shell -u root -p ${ACCUMULO_PASSWORD} -e "grant NameSpace.CREATE_TABLE -ns ${NAMESPACE} -u root"

  echo "Registering iterators..."
  accumulo shell -u root -p ${ACCUMULO_PASSWORD} -e "config -s general.vfs.context.classpath.geomesa=hdfs://{HADOOP_MASTER_ADDRESS}:8020/geomesa-classpath/[^.].*.jar"
  accumulo shell -u root -p ${ACCUMULO_PASSWORD} -e "config -ns ${NAMESPACE} -s table.classpath.context=${NAMESPACE}"
  echo "Geomesa iterator loadng complete"
fi


# GEOWAVE iterator installation
if [ "$1" = "geowave" ]; then

  if [ ! -d /usr/local/geowave ]; then
    echo "Downloading geowave"
    rpm -Uvh --replacepkgs http://s3.amazonaws.com/geowave-rpms/release/noarch/geowave-repo-1.0-3.noarch.rpm
    yum --enablerepo=geowave install -y geowave-${GEOWAVE_VERSION}-apache-accumulo
    yum --enablerepo=geowave install -y geowave-${GEOWAVE_VERSION}-apache-tools
  fi

  if ! $(hadoop fs -test -d /geowave-classpath); then
    hadoop fs -mkdir /geowave-classpath
  fi

  # Put the geowave libs on the dynamic classpath
  if [ ! -f /opt/accumulo/lib/ext/geowave-accumulo.jar ]; then
    echo "adding geowave to hdfs"
    cp /usr/local/geowave/accumulo/geowave-accumulo.jar /opt/accumulo/lib/ext/geowave-accumulo.jar
  fi

  echo "Creating geowave namespace '${NAMESPACE}'"
  accumulo shell -u root -p ${ACCUMULO_PASSWORD} -e "createnamespace ${NAMESPACE}"

  echo "Granting table creation rights..."
  accumulo shell -u root -p ${ACCUMULO_PASSWORD} -e "grant NameSpace.CREATE_TABLE -ns ${NAMESPACE} -u root"

  echo "Registering iterators..."
  accumulo shell -u root -p ${ACCUMULO_PASSWORD} -e "config -s general.vfs.context.classpath.geowave=hdfs://{HADOOP_MASTER_ADDRESS}:8020/geowave-classpath/[^.].*.jar"
  accumulo shell -u root -p ${ACCUMULO_PASSWORD} -e "config -ns ${NAMESPACE} -s table.classpath.context=${NAMESPACE}"
  echo "Geowave iterators loaded successfully"
fi

