# GeoDocker Runners

Shell scripts to run containers.

# Scripts arguments description

## Zookeepers

```bash
  Options:
    -t=<tag>     | --tag=<tag>                 Image tag [default: latest].
    -zi=<number> | --zookeeper-id=<number>     ZooKeeper self id.
    -zs1=<name>  | --zookeeper-server-1=<name> ZooKeeper server number 1.
    -zs2=<name>  | --zookeeper-server-2=<name> ZooKeeper server number 2.
    -zs2=<name>  | --zookeeper-server-2=<name> ZooKeeper server number 3.    
```

## Hadoop

```bash
  Options:
    -t=<tag>    | --tag=<tag>                    Image tag [default: latest].
    -hma=<name> | --hadoop-master-address=<name> Hadoop master name.    
```

## Accumulo

```bash
  Options:
    -t=<tag>     | --tag=<tag>                    Image tag [default: latest].
    -hma=<name>  | --hadoop-master-address=<name> Hadoop master name.
    -az=<names>  | --accumulo-zookeepers=<names>  ZooKeeper addresses.
    -as=<string> | --accumulo-secret=<string>     Accumulo secret.
    -ap=<string> | --accumulo-password=<string>   Accumulo password.
    -in=<string> | --instance-name=<string>       Accumulo instance name.
```

## Spark

```bash
  Options:
    -t=<tag>    | --tag=<tag>                    Image tag [default: latest].
    -hma=<name> | --hadoop-master-address=<name> Hadoop master name.
    -sm=<name>  | --spark-master=<name>          Spark master node name. 
```
