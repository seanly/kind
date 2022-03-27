# vim: set ft=dockerfile:

ARG OPENJDK_IMAGE_VERSION=17-jdk-oraclelinux8
FROM openjdk:${OPENJDK_IMAGE_VERSION}

MAINTAINER Seanly Liu(seanly@aliyun.com)

COPY ./rootfs /

ONBUILD COPY ./dist/ /data/service/

WORKDIR /data/service/

ENTRYPOINT ["/entrypoint.sh"]
