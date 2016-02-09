# GeoTrellis

Provides [GeoTrellis](https://github.com/geotrellis/geotrellis) installations and run test applications.

## Scripts description

* `install.sh` — installs [GeoTrellis](https://github.com/geotrellis/geotrellis) and [GeoTrellis Chattanooga demo](https://github.com/pomadchin/geotrellis-chatta-demo)
* `update.sh` — updates [GeoTrellis](https://github.com/geotrellis/geotrellis) and [GeoTrellis Chattanooga demo](https://github.com/pomadchin/geotrellis-chatta-demo)

## Run test example

[GeoTrellis](https://github.com/geotrellis/geotrellis) demo consists of two parts: web service and tiles ingest. Follow these steps to run demo:

1. Run the [ingest](./ingest.sh) script:
    ```bash
    ./ingest.sh
    ```

4. Run server ([run-server](./run-server.sh)): 
    ```bash
    ./run-server.sh
    ```

Server would be available at `localhost:8777`.
