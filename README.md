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

## Usage

Start the pods with: `kubectl create -f devpi-app.yaml`
Stop the pods with: `kubectl delete -f devpi-app.yaml`

To use the index, modify `~/.pip/pip.conf` and change the index url:

```
[global]
index-url = http://testuser:testpassword@192.168.99.100:31926/root/pypi/+simple/

[install]
trusted-host = 192.168.99.100
```
