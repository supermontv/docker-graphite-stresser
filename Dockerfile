FROM phusion/baseimage
MAINTAINER niall_creech@yahoo.co.uk

env WORKDIR /app
WORKDIR ${WORKDIR}

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

# Environment variables setup
COPY files/container_environment/* /etc/container_environment/

# APT packages setup
RUN apt-get update
RUN apt-get -y install \
  git \
  default-jre


# Git packages setup
RUN git clone https://github.com/feangulo/graphite-stresser.git ${WORKDIR}

# Daemons setup
RUN mkdir -p /etc/service/graphite-stresser
ADD files/service/graphite-stresser/run /etc/service/graphite-stresser/run

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
