#!/bin/bash

set -eux

chown -R user7:group7    /usr/local/memcached

/usr/local/memcached/bin/memcached --user=root \
--port=11211 \
--memory-limit=128 \
--conn-limit=1024 \
--threads=4 \
--pidfile=/tmp/memcached.pid \
--daemon

chown -R user7:group7    /usr/local/memcached
