#!/bin/sh
set -e

export DEVPI_SERVERDIR=/data/server
export DEVPI_CLIENTDIR=/data/client
export DEVPI_HOST="0.0.0.0"
export DEVPI_PORT=3141

if [ "$1" = "devpi-server" ]; then
    if [ ! -f "${DEVPI_SERVERDIR}/.serverversion" ]; then
        echo "Initializing devpi-server"

        devpi-server --restrict-modify root --start --host "${DEVPI_HOST}" --port "${DEVPI_PORT}"
        devpi-server --status
        devpi use "http://${DEVPI_HOST}:${DEVPI_PORT}"
        devpi login root --password=''
        devpi user -m root password="${DEVPI_PASSWORD}"
        devpi index -y -c public pypi_whitelist='*'
        devpi-server --stop
        devpi-server --status
    fi

    echo "Starting devpi-server"
    exec devpi-server --restrict-modify root --host "$DEVPI_HOST" --port "$DEVPI_PORT"
fi

exec "$@"
