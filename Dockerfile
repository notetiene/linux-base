ARG VERSION=latest
FROM ubuntu:$VERSION

MAINTAINER Etienne Prud’homme <e.e.f.prudhomme@gmail.com>

ENV DEBIAN_FRONTEND noninteractive

RUN echo 'APT::Get::Assume-Yes "true";' >> /etc/apt/apt.conf \
    && apt-get update && apt-get upgrade \
    && apt-get install \
    apt-utils

RUN apt-get install \
    pkg-config
    bash \
    bash-completion \
    sudo \
    gzip \
    tar \
    unzip \
    curl \
    wget \
    gawk \
    ispell \
    hunspell \
    attr \
    build-essential \
    valgrind \
    autoconf \
    automake \
    autotools-dev \
    make \
    texinfo \
    man \
    manpages \
    vim \
    mg

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
