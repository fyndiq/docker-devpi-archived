#!/bin/sh
set -e

export DEVPI_SERVERDIR=/data/server
export DEVPI_CLIENTDIR=/data/client
export DEVPI_USER="dev"

if [ "$1" = "devpi-server" ]; then
    if [ ! -f "${DEVPI_SERVERDIR}/.serverversion" ]; then
        echo "Initializing devpi-server"

        # start server and connect
        devpi-server --start --host 127.0.0.1 --port 3141
        devpi-server --status
        devpi use http://localhost:3141

        # set password for root user
        devpi login root --password=''
        devpi user -m root password=''
        devpi logoff

        # register new user and create index
        devpi user -c fyndiq password=fyndiq
        devpi login fyndiq --password=fyndiq
        devpi index -c dev bases=root/pypi

        # stop server
        devpi-server --stop
        devpi-server --status
    fi

    echo "Starting devpi-server"
    exec devpi-server --restrict-modify root --host 0.0.0.0 --port 3141
fi

exec "$@"
