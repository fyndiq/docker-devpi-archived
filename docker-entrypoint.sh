#!/bin/sh
set -e

export DEVPI_PORT="3141"
export DEVPI_SERVERDIR="/data/server"
export DEVPI_CLIENTDIR="/data/client"
export DEVPI_ROOT_PASSWORD=""
export DEVPI_USER="fyndiq"
export DEVPI_USER_PASSWORD="fyndiq"
export DEVPI_USER_INDEX="dev"

if [ "$1" = "devpi-server" ]; then
    if [ ! -f "${DEVPI_SERVERDIR}/.serverversion" ]; then
        echo "[RUN]: Initializing devpi-server"

        # start server and connect
        devpi-server --start --host 127.0.0.1 --port ${DEVPI_PORT}
        devpi-server --status
        devpi use http://localhost:${DEVPI_PORT}

        # set password for root user
        devpi login root --password=${DEVPI_ROOT_PASSWORD}
        devpi user -m root password=${DEVPI_ROOT_PASSWORD}
        devpi logoff

        # register new user with create index
        devpi user -c ${DEVPI_USER} password=${DEVPI_USER_PASSWORD}
        devpi login ${DEVPI_USER} --password=${DEVPI_USER_PASSWORD}
        devpi index -c ${DEVPI_USER_INDEX} bases=root/pypi

        # stop server
        devpi-server --stop
        devpi-server --status
    fi

    echo "[RUN]: Starting devpi-server"
    exec devpi-server --restrict-modify root --host 0.0.0.0 --port ${DEVPI_PORT}
fi

exec "$@"
