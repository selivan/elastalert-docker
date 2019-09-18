# ElastAlert-Docker

This Dockerfile will build a Docker image of ElastAlert. It is based on https://github.com/jertel/elastalert-docker

## Staleness

This image is certainly going to become stale over time. If you notice it has gone stale and needs rebuilt, you are welcome to create an issue at https://github.com/selivan/elastalert-docker and I'll trigger the automated build over at Docker Hub. Or just fork it and build your fresh image on Docker Hub.

## Docker Hub

The pre-built image is available at

## Building Locally

To build, install Docker and then run the following command:

```
docker build . -t elastalert
```

## Running

Executable name (one of elastalert|elastalert-create-index|elastalert-test-rule) should be the first parameter, `--config` option is always present and other parameters are passed as they are.
