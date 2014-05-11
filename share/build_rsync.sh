#!/bin/bash

# This script builds a static version of rsync for amd64 and i386
# You need docker to run this script

VERSION=3.1.0
ARCHIVE=rsync-${VERSION}.tar.gz

wget -nc http://rsync.samba.org/ftp/rsync/src/rsync-${VERSION}.tar.gz
rm -rf rsync_src/
mkdir rsync_src/
tar xvfz ${ARCHIVE} -C rsync_src/ --strip-components 1

docker run -t -i -v $(pwd)/rsync_src:/src debian:squeeze \
    /bin/bash -c "apt-get update && apt-get install -y build-essential && cd /src && ./configure CFLAGS=\"${CFLAGS} -static\" && make"

mkdir -p rsync_static
mv rsync_src/rsync rsync_static/rsync_x64

rm -rf rsync_src/
mkdir rsync_src/
tar xvfz ${ARCHIVE} -C rsync_src/ --strip-components 1
docker run -t -i -v $(pwd)/rsync_src:/src sugi/debian-i386 \
    /bin/bash -c "apt-get update && apt-get install -y build-essential && cd /src && ./configure CFLAGS=\"${CFLAGS} -static\" && make"

mkdir -p rsync_static
mv rsync_src/rsync rsync_static/rsync_x32
