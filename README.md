docker-devpi
============

A docker image for devpi-server.

## Authentication

The server is password protected via http basic auth. To log-in you'll
need to create a htpasswd file at `/etc/nginx-htpasswd/htpasswd`.

Example:

`htpasswd -bn testuser testpassword > htpasswd`

In Kubernetes, you'll need to create a secret from this file:

`kubectl create secret generic nginx-htpasswd --from-file=htpasswd`
