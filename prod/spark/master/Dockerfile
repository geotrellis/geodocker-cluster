FROM daunnc/geodocker-spark-base:latest

MAINTAINER Pomadchin Grigory, daunnc@gmail.com

# EXPOSE 6066 7077 8080

ENTRYPOINT [ "/sbin/entrypoint.sh" ]
CMD /bin/bash -c "spark-class org.apache.spark.deploy.master.Master --host $(hostname)"
