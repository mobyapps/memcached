FROM phusion/baseimage:0.11

LABEL maintainer="charescape@outlook.com"

ENV MEMCACHED_VERSION 1.5.19

COPY ./src/memcached-1.5.19.tar.gz    /usr/local/src/
COPY ./startserv.sh                   /etc/my_init.d/

# see http://www.ruanyifeng.com/blog/2017/11/bash-set.html
RUN set -eux \
&& export DEBIAN_FRONTEND=noninteractive \
&& sed -i 's/http:\/\/archive.ubuntu.com/https:\/\/mirrors.aliyun.com/' /etc/apt/sources.list \
&& sed -i 's/http:\/\/security.ubuntu.com/https:\/\/mirrors.aliyun.com/' /etc/apt/sources.list \
&& sed -i 's/https:\/\/archive.ubuntu.com/https:\/\/mirrors.aliyun.com/' /etc/apt/sources.list \
&& sed -i 's/https:\/\/security.ubuntu.com/https:\/\/mirrors.aliyun.com/' /etc/apt/sources.list \
&& apt-get -y update            \
&& apt-get -y upgrade           \
&& apt-get -y install           \
build-essential                 \
libevent-dev                    \
libssl-dev                      \
\
&& groupadd group7 \
&& useradd -g group7 -M -d /usr/local/memcached user7 -s /sbin/nologin \
\
&& chmod +x /etc/my_init.d/startserv.sh \
\
&& cd /usr/local/src \
\
&& tar -zxf memcached-${MEMCACHED_VERSION}.tar.gz \
\
&& cd /usr/local/src/memcached-${MEMCACHED_VERSION} \
&& ./configure --prefix=/usr/local/memcached \
--runstatedir=/usr/local/memcached/rsdir \
--datadir=/usr/local/memcached/ddir \
--enable-64bit \
--enable-seccomp \
--enable-tls \
\
&& make && make install \
\
&& echo '' >> ~/.bashrc \
&& echo 'export PATH="$PATH:/usr/local/memcached/bin"' >> ~/.bashrc \
\
&& apt-get clean \
&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
&& rm -rf /usr/local/src/*

EXPOSE 11212

CMD ["/sbin/my_init"]

# source ~/.bashrc
