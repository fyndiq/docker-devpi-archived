FROM python:3.5.2-alpine

RUN addgroup -S devpi && adduser -S -G devpi devpi

ENV DEVPI_SERVER_VERSION=4.1.0 \
    DEVPI_CLIENT_VERSION=2.6.4

RUN pip install --no-cache-dir devpi-server=="${DEVPI_SERVER_VERSION}" \
                               devpi-client=="${DEVPI_CLIENT_VERSION}"

RUN mkdir /data && chown devpi:devpi /data
VOLUME /data
WORKDIR /data

COPY docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 3141
CMD ["devpi-server"]
