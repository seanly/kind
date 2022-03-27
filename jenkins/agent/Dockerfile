FROM ghcr.io/linuxsuren/hd:v0.0.55 as downloader

FROM jenkins/inbound-agent:alpine

MAINTAINER Seanly Liu<seanly@aliyun.com>

USER root
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories && apk update
COPY --from=downloader /usr/local/bin/hd /usr/local/bin/hd

RUN apk add --no-cache docker docker-compose supervisor curl 

# install tools
RUN hd install rancher/dapper

# install jenkins-swarm client
ARG SWARM_VERSION=3.27
RUN curl --create-dirs -sSLo /usr/share/jenkins/swarm-client.jar \
    https://repo.jenkins-ci.org/artifactory/releases/org/jenkins-ci/plugins/swarm-client/${SWARM_VERSION}/swarm-client-${SWARM_VERSION}.jar \
  && chmod 755 /usr/share/jenkins \
  && chmod 644 /usr/share/jenkins/swarm-client.jar

COPY ./rootfs /

VOLUME /var/lib/docker
EXPOSE 2375

ARG ENABLE_SERVICE=jenkins-agent
RUN mv /etc/supervisor/conf.d/${ENABLE_SERVICE}.conf.disable /etc/supervisor/conf.d/${ENABLE_SERVICE}.conf

RUN mkdir -p /var/log/supervisor/
ENTRYPOINT ["supervisord", "--nodaemon", "--configuration", "/etc/supervisord.conf"]
