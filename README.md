# ElastAlert-Docker

This Dockerfile will build a Docker image of ElastAlert. It is based on https://github.com/jertel/elastalert-docker

## Docker Hub and staleness

The pre-built image is available at https://hub.docker.com/r/selivan/elastalert-docker. It is certainly going to become stale over time, so it is easier to build a fresh image localy.

## Building Locally

To build, install Docker and then run the following command:

```
docker build . -t elastalert-docker
```

## Running

Executable name (one of `elastalert|elastalert-create-index|elastalert-test-rule`) should be the first parameter, `--config /opt/config/elastalert_config.yaml` option is always present and other parameters are passed as they are.

I suggest to invoke `docker run` with `--init` option, that will properly forward signals and reap zombie processes(see [docs](https://docs.docker.com/compose/compose-file/#init)).
