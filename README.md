# ElastAlert-Docker

This Dockerfile will build a Docker image of [ElastAlert](https://github.com/Yelp/elastalert). It is based on [jertel/elastalert-docker](https://github.com/jertel/elastalert-docker).

## Docker Hub and staleness

The pre-built image is available at DockerHub: [selivan/elastalert-docker](https://hub.docker.com/r/selivan/elastalert-docker). It is going to become stale over time, so it is easier for you to build a fresh image locally.

## Building localy

To build, install Docker and then run the following command:

```
docker build -t elastalert-docker --build-arg ELASTALERT_GIT_BRANCH=master .
```

## Running

Executable name (one of `elastalert|elastalert-create-index|elastalert-test-rule`) should be the first parameter, `--config /opt/elastalert/config/config.yaml` option is always present and other parameters are passed as they are.

Config file `config.yml` should have line `rules_folder: /opt/rules`.

I suggest to invoke `docker run` with `--init` option, that will properly forward signals and reap zombie processes(see Docker [docs](https://docs.docker.com/compose/compose-file/#init)).

### docker run

```bash
# Create user to run container
adduser --disabled-password --home /nowhere --no-create-home elastalert
# Create elastalert writeback index
docker run --init --user $(id -u elastalert) -v /etc/elastalert:/opt/config -v /etc/elastalert/rules:/opt/rules --rm selivan/elastalert-docker elastalert-create-index
# See possible options
docker run --init --user $(id -u elastalert) --rm selivan/elastalert-docker elastalert --help
# Run elastalert
docker run --init --user $(id -u elastalert) --restart=unless-stopped --name elastalert-docker -v /etc/elastalert:/opt/config -v /etc/elastalert/rules:/opt/rules -d selivan/elastalert-docker elastalert --pin_rules --start NOW
```

### docker-compose

`docker-compose.yml`:

```yaml
version: '3'
services:
  elastalert-create-index:
    # Use to prevent Docker from messing with iptables rules
    #network_mode: host
    init: true
    # Get by command: id -u elastalert
    user: "1002"
    restart: "no"
    image: selivan/elastalert-docker
    command: elastalert-create-index
    volumes:
      - /etc/elastalert:/opt/config
      - /etc/elastalert/rules:/opt/rules
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
      - /etc/elastalert:/opt/config
      - /etc/elastalert/rules:/opt/rules
    # Log rotation
    logging:
      driver: "json-file"
      options:
        max-size: "10m"
        max-file: "5"
        compress: "true"
```
