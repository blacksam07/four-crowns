#!/bin/sh

set -e

if [ "$1" = 'postgres' ]; then
    pg_ctlcluster 12 main start
fi

exec "$@"