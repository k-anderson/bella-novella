#!/bin/sh
# Persist PKG_CONFIG_PATH for builds and pkg-config discovery
export PKG_CONFIG_PATH="/usr/local/lib/pkgconfig:/usr/local/freeswitch/lib/pkgconfig:${PKG_CONFIG_PATH:-}"
