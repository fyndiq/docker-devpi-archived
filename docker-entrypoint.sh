#!/bin/sh
set -e

: "${DEVPI_SERVERDIR:="/data/server"}"
: "${DEVPI_CLIENTDIR:="/data/client"}"

echo "DEVPI_SERVERDIR is ${DEVPI_SERVERDIR}"
echo "DEVPI_CLIENTDIR is ${DEVPI_CLIENTDIR}"

export DEVPI_SERVERDIR DEVPI_CLIENTDIR

if [ "$1" = "devpi-server" ]; then
    if [ ! -f "${DEVPI_SERVERDIR}/.serverversion" ]; then
        echo "Initializing devpi-server"

        if [ -z "$DEVPI_ROOT_PASSWORD" ]; then
            echo >&2 'error: you need to specify DEVPI_ROOT_PASSWORD'
            exit 1
        fi

        # start server and connect
        devpi-server --start --host 127.0.0.1 --port 3141
        devpi-server --status
        devpi use http://localhost:3141

        # set password for root user
        devpi login root --password=""
        devpi user -m root password="${DEVPI_ROOT_PASSWORD}"
        devpi logoff

        # create user and index
        devpi user -c "${DEVPI_USER}" password="${DEVPI_PASSWORD}"
        devpi login "${DEVPI_USER}" --password="${DEVPI_PASSWORD}"
        devpi index -c "${DEVPI_INDEX}" bases=root/pypi
        devpi logoff

        # stop server
        devpi-server --stop
        devpi-server --status

        echo 'Init process done. Ready for start up.'
    fi

    echo "Starting devpi-server"
    exec devpi-server --restrict-modify root --host 0.0.0.0 --port 3141
fi

exec "$@"
