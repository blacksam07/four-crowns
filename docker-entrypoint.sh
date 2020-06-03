#!/bin/sh

set -e
pg_ctlcluster 12 main start
exec "$@"