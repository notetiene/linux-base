ARG VERSION=latest
FROM ubuntu:$VERSION

MAINTAINER Etienne Prud’homme <e.e.f.prudhomme@gmail.com>

ENV DEBIAN_FRONTEND noninteractive

RUN echo 'APT::Get::Assume-Yes "true";' >> /etc/apt/apt.conf \
    && apt-get update && apt-get upgrade

RUN apt-get install \
    apt-utils \
    aptitude \
    bash \
    bash-completion \
    sudo \
    psmisc

RUN apt-get install \
    gzip \
    tar \
    unzip \
    curl \
    wget \
    gawk \
    attr \
    cron \
    sl

RUN apt-get install \
    build-essential \
    make \
    pkg-config

RUN apt-get install \
    vim \
    mg

RUN apt-get install \
    traceroute \
    iputils-ping \
    iputils-arping \
    whois \
    dnsutils

RUN mkdir -p /tmp/linux-base

COPY bash_completion.patch /tmp/linux-base

RUN patch -d/ -p0 < /tmp/linux-base/bash_completion.patch

RUN cd /tmp/linux-base \
    && wget "https://sourceforge.net/projects/porg/files/latest/download" -O porg-latest.tar.gz \
    && tar xzf porg-latest.tar.gz \
    && cd porg-[0-9.]* \
    && ./configure --disable-grop \
    && make -j4 \
    && make install \
    && make logme-really

RUN rm -Rf /tmp/linux-base

RUN tac /etc/apt/apt.conf \
    | sed '0,/APT::Get::Assume-Yes "true";/{/APT::Get::Assume-Yes "true";/d;}' \
    | tac > /etc/apt/apt.conf
