FROM python:3.6-alpine

LABEL description="ElastAlert based on image by Jason Ertel (jertel at codesim.com)"
LABEL maintainer="Pavel Selivanov(https://github.com/selivan)"

ARG ELASTALERT_VERSION=0.2.1

RUN apk --update upgrade && \
    apk add gcc libffi-dev musl-dev python-dev openssl-dev tzdata libmagic && \
    rm -rf /var/cache/apk/* &&\
    pip install elastalert==${ELASTALERT_VERSION} && \
    rm -fr /root/.pip/cache && \
    apk del gcc libffi-dev musl-dev python-dev openssl-dev && \
    mkdir -p /opt/elastalert/config && \
    mkdir -p /opt/elastalert/rules

ADD run.sh /opt/elastalert/run.sh

RUN chmod a+rx /opt/elastalert/run.sh

ENV TZ "UTC"

VOLUME [ "/opt/elastalert/config", "/opt/rules" ]
WORKDIR /opt/elastalert
ENTRYPOINT ["/opt/elastalert/run.sh"]
