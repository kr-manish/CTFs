This repo contains all the scripts written to automate different processes that are mostly used in any CTFs.

**File Name -- Purpose**

zip_inception_extractor.py -- Extract multiple sub zips using loops and zipfile

## How to run the container
docker pull yourusername/parrot-ctf:latest
docker run -it \
    -e DISPLAY=host.docker.internal:0 \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -v $(pwd)/results:/results \
    yourusername/parrot-ctf:latest

## python env for python tools installed
source /opt/ctfenv/bin/activate

