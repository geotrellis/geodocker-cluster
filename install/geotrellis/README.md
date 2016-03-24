# GeoTrellis

Provides [GeoTrellis](https://github.com/geotrellis/geotrellis) installations and run test applications.

## Scripts description

* `install.sh` — installs [GeoTrellis](https://github.com/geotrellis/geotrellis) and [GeoTrellis Chattanooga demo](https://github.com/pomadchin/geotrellis-chatta-demo)
  * `install.sh` has a `-s=<scala version> | --scala=<scala version>` argument, provide it if you want to test a specific Scala version.

* `update.sh` — updates [GeoTrellis](https://github.com/geotrellis/geotrellis) and [GeoTrellis Chattanooga demo](https://github.com/pomadchin/geotrellis-chatta-demo)

## Run test example

[GeoTrellis](https://github.com/geotrellis/geotrellis) [demo](https://github.com/geotrellis/geotrellis-chatta-demo) consists of two parts: web service and tiles ingest. Demo used: [https://github.com/geotrellis/geotrellis-chatta-demo](https://github.com/geotrellis/geotrellis-chatta-demo).

1. Run the [ingest](./ingest.sh) script to ingest demo data:
    ```bash
    ./ingest.sh
    ```

2. Run server ([run-server](./run-server.sh)): 
    ```bash
    ./run-server.sh
    ```

Server would be available at `localhost:8777`.

This demo would be installed into `/data` directory, inside the container.

Demo depends on [GeoTrellis](https://github.com/geotrellis/geotrellis) RC1.