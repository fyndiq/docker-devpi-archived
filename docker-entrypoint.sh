#!/bin/sh
set -e

: "${DEVPI_PORT:=3141}"
: "${DEVPI_SERVERDIR:=/data/server}"
: "${DEVPI_CLIENTDIR:=/data/client}"
: "${DEVPI_ROOT_PASSWORD:=123}"
: "${DEVPI_USER_NAME:=testuser}"
: "${DEVPI_USER_PASSWORD:=456}"
: "${DEVPI_USER_INDEX:=dev}"

if [ "$1" = "devpi-server" ]; then
    if [ ! -f "${DEVPI_SERVERDIR}/.serverversion" ]; then
        echo "[RUN]: Initializing devpi-server"

        # start server and connect
        devpi-server --start --host 127.0.0.1 --port "${DEVPI_PORT}"
        devpi-server --status
        devpi use http://localhost:"${DEVPI_PORT}"

        # set password for root user
        devpi login root --password=""
        devpi user -m root password="${DEVPI_ROOT_PASSWORD}"
        devpi logoff

        # register new user and create index
        devpi user -c "${DEVPI_USER_NAME}" password="${DEVPI_USER_PASSWORD}"
        devpi login "${DEVPI_USER_NAME}" --password="${DEVPI_USER_PASSWORD}"
        devpi index -c "${DEVPI_USER_INDEX}" bases=root/pypi

        # stop server
        devpi-server --stop
        devpi-server --status
    fi

    echo "[RUN]: Starting devpi-server"
    exec devpi-server --restrict-modify root --host 0.0.0.0 --port "${DEVPI_PORT}"
fi

exec "$@"
