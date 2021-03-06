FROM ubuntu:14.04
MAINTAINER CREATIVE AREA

ENV DEBIAN_FRONTEND noninteractive
ENV COLLECTD_VERSION 5.5.0
ENV COLLECTD_PATH /opt/collectd
ENV LOGSTASH_SERVER logstash
ENV LOGSTASH_PORT 25826

ADD http://collectd.org/files/collectd-${COLLECTD_VERSION}.tar.gz /tmp/

RUN apt-get update && apt-get install -yq --no-install-recommends build-essential libcurl4-openssl-dev git python-dev python-pip

RUN cd /tmp && \
  tar xzf collectd-${COLLECTD_VERSION}.tar.gz && \
  cd collectd-${COLLECTD_VERSION} && \
  ./configure --prefix=${COLLECTD_PATH} --enable-network --enable-python && \
  make && \
  make install

#install redis in order to push things to redis
#to be updated #cant load plugin redis
RUN git clone https://github.com/redis/hiredis.git ${COLLECTD_PATH}/redis && \
  cd ${COLLECTD_PATH}/redis && \
  make && \
  make install
  
#install stuff for rrdtools

#install docker-collectd plugin to record metrics about docker containers
RUN git clone https://github.com/lebauce/docker-collectd-plugin.git ${COLLECTD_PATH}/share/docker-collectd-plugin && \
  pip install -r ${COLLECTD_PATH}/share/docker-collectd-plugin/requirements.txt

RUN rm -rf /tmp/collectd-${COLLECTD_VERSION} && \
  apt-get remove --purge -y build-essential git libcurl4-openssl-dev python-dev && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

COPY collectd.conf ${COLLECTD_PATH}/etc/collectd.conf

COPY start.sh /collectd_start.sh
RUN chmod a+x /collectd_start.sh

CMD /collectd_start.sh