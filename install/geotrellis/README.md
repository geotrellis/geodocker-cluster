# GeoTrellis

Provides [GeoTrellis](https://github.com/geotrellis/geotrellis) install and run test applications scripts.

## Scripts description

* `install.sh` — installs [GeoTrellis](https://github.com/geotrellis/geotrellis) and [GeoTrellis Chattanooga demo](https://github.com/pomadchin/geotrellis-chatta-demo)
* `update.sh` — updates [GeoTrellis](https://github.com/geotrellis/geotrellis) and [GeoTrellis Chattanooga demo](https://github.com/pomadchin/geotrellis-chatta-demo)

## Run tests

[GeoTrellis](https://github.com/geotrellis/geotrellis) demo consists of two parts: web service and ingest tiles. Steps to see demo:

1. Enter the master container: 
    ```bash
    docker exec -it master1 bash
    ```

2. Enter the [GeoTrellis Chattanooga demo](https://github.com/pomadchin/geotrellis-chatta-demo) project folder:
    ```bash
    cd ./geotrellis-chatta-demo/geotrellis
    ```

3. Run the ingest script:
    ```bash
    ./ingest.sh
    ```

4. Run server: 
    ```bash
    zip -d target/scala-2.10/GeoTrellis-Tutorial-Project-assembly-0.1-SNAPSHOT.jar META-INF/ECLIPSEF.RSA
    zip -d target/scala-2.10/GeoTrellis-Tutorial-Project-assembly-0.1-SNAPSHOT.jar META-INF/ECLIPSEF.SF
    
    java -cp target/scala-2.10/GeoTrellis-Tutorial-Project-assembly-0.1-SNAPSHOT.jar geotrellis.chatta.Main
    ```

Server would be available at `localhost:8777`.