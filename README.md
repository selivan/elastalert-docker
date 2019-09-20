# ElastAlert-Docker

This Dockerfile will build a Docker image of ElastAlert. It is based on https://github.com/jertel/elastalert-docker

## Docker Hub and staleness

The pre-built image is available at https://hub.docker.com/r/selivan/elastalert-docker. It is certainly going to become stale over time, so it is easier to build a fresh image localy.

## Building localy

To build, install Docker and then run the following command:

```
docker build -t elastalert-docker --build-arg ELASTALERT_VERSION=0.2.1 .
```

## Running

Executable name (one of `elastalert|elastalert-create-index|elastalert-test-rule`) should be the first parameter, `--config /opt/config/config.yaml` option is always present and other parameters are passed as they are.

I suggest to invoke `docker run` with `--init` option, that will properly forward signals and reap zombie processes(see [docs](https://docs.docker.com/compose/compose-file/#init)).

### docker run

```bash
adduser --disabled-password --home /nowhere --no-create-home elastalert
docker run --init --user $(id -u elastalert) -v /etc/elastalert:/opt/elastalert/config -v /etc/elastalert/rules:/opt/elastalert/rules --rm selivan/elastalert-docker elastalert-create-index
# See possible options
docker run --init --user $(id -u elastalert) --rm selivan/elastalert-docker elastalert --help
docker run --init --user $(id -u elastalert) --restart=unless-stopped --name elastalert-docker -v /etc/elastalert:/opt/elastalert/config -v /etc/elastalert/rules:/opt/elastalert/rules -d selivan/elastalert-docker elastalert --pin_rules --start NOW
```

### docker-compose

`docker-compose.yml`:

```yaml
version: '3'
services:
  elastalert-create-index:
    network_mode: host
    init: true
    user: "{{ elastalert_user_id }}"
    restart: "no"
    image: selivan/elastalert-docker
    command: elastalert-create-index
    volumes:
      - /etc/elastalert:/opt/elastalert/config
      - /etc/elastalert/rules:/opt/elastalert/rules
    logging:
      driver: "json-file"
      options:
        max-size: "10m"
        max-file: "5"
        compress: "true"
  elastalert:
    # Use to prevent Docker from messing with iptables rules
    #network: host
    init: true
    # Get by command: id -u elastalert
    user: "1002"
    restart: unless-stopped
    image: selivan/elastalert-docker
    command: elastalert --pin_rules --verbose --start NOW
    volumes:
      - /etc/elastalert:/opt/elastalert/config
      - /etc/elastalert/rules:/opt/elastalert/rules
    # Log rotation
    logging:
      driver: "json-file"
      options:
        max-size: "10m"
        max-file: "5"
        compress: "true"
```

`config.yaml` should have entry `rules_folder: /opt/elastalert/rules`.
