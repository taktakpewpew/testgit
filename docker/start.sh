#! /bin/bash
set -e

exec "$COLLECTD_PATH/sbin/collectd" -f
