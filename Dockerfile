FROM python:3.6-alpine

LABEL description="ElastAlert based on image by Jason Ertel (jertel at codesim.com)"
LABEL maintainer="Pavel Selivanov(https://github.com/selivan)"

ARG ELASTALERT_GIT_BRANCH=master
ARG ELASTALERT_GIT_REPO=https://github.com/Yelp/elastalert.git

RUN apk --update upgrade && \
    apk add gcc git libffi-dev musl-dev python-dev openssl-dev tzdata libmagic && \
    rm -rf /var/cache/apk/* &&\
    cd /root &&\
    git clone --depth 1 --single-branch --branch ${ELASTALERT_GIT_BRANCH} ${ELASTALERT_GIT_REPO} &&\
    cd elastalert &&\
    pip install --upgrade pip && pip install setuptools>=11.3 &&\
    python setup.py install &&\
    rm -fr /root/.pip/cache && \
    rm -fr /root/elastalert && \
    apk del git gcc libffi-dev musl-dev python-dev openssl-dev && \
    mkdir -p /opt/config && \
    mkdir -p /opt/rules

ADD run.sh /opt/run.sh

RUN chmod a+rx /opt/run.sh

ENV TZ "UTC"

VOLUME [ "/opt/config", "/opt/rules" ]
WORKDIR /opt
ENTRYPOINT ["/opt/run.sh"]
